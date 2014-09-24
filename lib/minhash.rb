require 'murmurhash3'
require 'set'

module Minhash
  # Generates the k-shingles for a String.
  #
  # For example, with the string "12345" and k = 3 the shingles are
  # "123", "234" and "345".
  #
  #     k_shingles("ABCDE", 3)
  #     # => ["ABC", "BCD", "CDE"]
  #
  # Normalizes all whitespace to be single character spaces.
  #
  # You want to select k to be large enough to be able to
  # distinguish chunks of text adequately - a value of around 9 is
  # sensible for reasonable sized chunks of standard written text.
  def self.k_shingles(text, k)
    if text.size < k
      [text]
    else
      text.tr("\t\n\r", "   ").
        squeeze(" ").
        each_char.
        each_cons(k).
        map(&:join)
    end
  end

  # Generates a Set of tokenized 32-bit integer k-shingles.
  #
  #    tokenized_k_shingles("ABCDE", 3)
  #    # =>  #<Set: {1136772405, 3561005568, 944681077}>
  #
  # MurmurHash3 is used by default; if you want to use a different
  # hash function, pass a block:
  #
  #    tokenized_k_shingles("ABCDE", 3) do |shingle|
  #      # obviously a terrible hash function, just an example.
  #      shingle[0].ord
  #    end
  #    # => #<Set: {65, 66, 67}>
  def self.tokenized_k_shingles(text, k, &hash)
    hash ||= lambda {|s| MurmurHash3::Native32.murmur3_32_str_hash(s) }
    k_shingles(text, k).map {|shingle| hash.call(shingle) }.to_set
  end

  # Returns the jaccard similarity between two sets of shingles /
  # tokens.
  def self.jaccard_similarity(a, b)
    (a & b).size / (a | b).size.to_f
  end

  # Returns the approximate jaccard similarity of 2 sets, given their
  # signatures.
  def self.approximate_similarity(a, b)
    a.length.times.select {|i| a[i] == b[i] }.size / a.length.to_f
  end

  # Mixin to extend String with k-shingle functions.
  module StringExtensions
    # Generates the k-shingles for this String.
    #
    # See Minhash::StringFunctions#k_shingles
    def k_shingles(k)
      Minhash.k_shingles self, k
    end

    # Generates the tokenized k-shingles for this String.
    #
    # See Minhash::StringFunctions#tokenized_k_shingles
    def tokenized_k_shingles(k, &block)
      Minhash.tokenized_k_shingles self, k, &block
    end
  end

  # The Minhash signature algorithm.
  #
  # See section 3.3 of the http://www.mmds.org/ book:
  # http://infolab.stanford.edu/~ullman/mmds/ch3.pdf
  #
  # Simple XORs of random integer bit masks are used as the hash
  # functions.
  class Algorithm
    # Returns the bit masks used to implement the hash functions.
    attr_reader :masks

    # Creates a new instance of the algorithm, with the given bit
    # masks.
    def initialize(masks)
      @masks = masks.freeze
      @hash_functions ||= @masks.map {|mask| lambda {|i| i ^ mask } }
    end

    # Creates a new instance of the algorithm with +length+ random bit
    # masks.
    def self.create(length)
      new length.times.map { rand(2 ** 32 -1) }
    end

    # Returns the minhash signature for a set of tokens.
    def signature(tokens)
      @hash_functions.map {|f| tokens.map(&f).min }
    end
  end  
end

class String
  include Minhash::StringExtensions
end

