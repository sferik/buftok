# frozen_string_literal: true

require_relative "duel_helper"

duel "flush: one buffered chunk" do |n|
  once { @chunk = line(80) }
  tokenizers = untimed do
    Array.new(n) { BufferedTokenizer.new.tap { |tokenizer| tokenizer.extract(@chunk) } }
  end
  tokenizers.each(&:flush)
end

duel "flush: 100 buffered chunks" do |n|
  once { @chunks = Array.new(100) { line(80) } }
  tokenizers = untimed do
    Array.new(n) do
      BufferedTokenizer.new.tap { |tokenizer| @chunks.each { |chunk| tokenizer.extract(chunk) } }
    end
  end
  tokenizers.each(&:flush)
end
