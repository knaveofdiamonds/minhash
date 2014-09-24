require 'spec_helper'

describe "Minhash" do
  describe "generating k-shingles of a string" do
    it "k-shingles text" do
      expect( "12345".k_shingles(3) ).to eql(["123", "234", "345"])
    end

    it "generates a single shingle when the string is smaller than k" do
      expect( "12".k_shingles(3) ).to eql(["12"])
    end

    it "replaces whitespace characters with a space" do
      expect( "\t2\t4\n".k_shingles(3) ).to eql([" 2 ", "2 4", " 4 "])
    end

    it "squeezes consecutive whitespace characters" do
      expect("22   \t  \n".k_shingles(3)).to eql(["22 "])
    end

    it "generates tokenized k-shingles" do
      expect("ABCDE".tokenized_k_shingles(3)).
        to eql(Set.new([1136772405, 3561005568, 944681077]))
    end

    it "tokenizes shingles with a custom hash function" do
      expect("ABCDE".tokenized_k_shingles(3) {|s| s[0].ord }).
        to eql(Set.new([65,66,67]))
    end
  end

  describe "generating a Minhash signature for text" do
    it "returns a signature of the tokens" do
      algorithm = Minhash::Algorithm.new([1,2])
      expect(algorithm.signature([1, 2, 3])).to eql([0, 0])
    end

    it "can create X masks internally" do
      algorithm = Minhash::Algorithm.create(20)
      expect(algorithm.masks.size).to eql(20)
      signature = algorithm.signature([1])
      expect(signature.size).to eql(20)
      expect(signature.all? {|i| i.instance_of?(Fixnum) }).to eql(true)
    end
  end

  it "returns the jaccard similarity of 2 sets" do
    a = Set.new([1,2,3])
    b = Set.new([2,3,4])
    expect(Minhash.jaccard_similarity(a,b)).to eql(0.5)
  end

  it "returns the approximate similarity for 2 signatures" do
    a = [1,2,3,4]
    b = [2,2,3,4]
    expect(Minhash.approximate_similarity(a,b)).to eql(0.75)
  end
end
