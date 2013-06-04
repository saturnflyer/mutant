require 'spec_helper'

describe Mutant::Mutator, 'def' do

  context 'with no arguments' do
    let(:source) { 'def foo; true; false; end' }

    let(:mutations) do
      mutations = []

      # Mutation of each statement in block
      mutations << 'def foo; true; true; end'
      mutations << 'def foo; false; false; end'
      mutations << 'def foo; true; nil; end'
      mutations << 'def foo; nil; false; end'

      # Remove statement in block
      mutations << 'def foo; true; end'
      mutations << 'def foo; false; end'

      # Remove all statements
      mutations << 'def foo; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'with arguments' do
    let(:source) { 'def foo(a, b); nil; end' }

    before do
      Mutant::Random.stub(:hex_string => 'random')
    end

    let(:mutations) do
      mutations = []

      # Deletion of each argument
      mutations << 'def foo(a); nil; end'
      mutations << 'def foo(b); nil; end'

      # Deletion of all arguments
      mutations << 'def foo; nil; end'

      # Rename each argument
      mutations << 'def foo(srandom, b); nil; end'
      mutations << 'def foo(a, srandom); nil; end'

      # Mutation of body
      mutations << 'def foo(a, b); ::Object.new; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'with argument beginning in an underscore' do
    let(:source) { 'def foo(_unused); end' }

    let(:mutations) do
      mutations = []
      mutations << 'def foo(_unused); ::Object.new; end'
      mutations << 'def foo; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'default argument' do
    let(:source) { 'def foo(a = true); end' }

    before do
      Mutant::Random.stub(:hex_string => 'random')
    end

    let(:mutations) do
      mutations = []
      mutations << 'def foo(a); end'
      mutations << 'def foo(); end'
      mutations << 'def foo(a = false); end'
      mutations << 'def foo(a = nil); end'
      mutations << 'def foo(a = true); ::Object.new; end'
      mutations << 'def foo(srandom = true); nil; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'define on singleton' do
    let(:source) { 'def self.foo; true; false; end' }

    let(:mutations) do
      mutations = []

      # Body presence mutations
      mutations << 'def self.foo; false; false; end'
      mutations << 'def self.foo; true; true; end'
      mutations << 'def self.foo; true; nil; end'
      mutations << 'def self.foo; nil; false; end'

      # Body presence mutations
      mutations << 'def self.foo; true; end'
      mutations << 'def self.foo; false; end'

      # Remove all statements
      mutations << 'def self.foo; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'define on singleton with argument' do

    before do
      Mutant::Random.stub(:hex_string => 'random')
    end

    let(:source) { 'def self.foo(a, b); nil; end' }

    let(:mutations) do
      mutations = []

      # Deletion of each argument
      mutations << 'def self.foo(a); nil; end'
      mutations << 'def self.foo(b); nil; end'

      # Deletion of all arguments
      mutations << 'def self.foo; nil; end'

      # Rename each argument
      mutations << 'def self.foo(srandom, b); nil; end'
      mutations << 'def self.foo(a, srandom); nil; end'

      # Mutation of body
      mutations << 'def self.foo(a, b); ::Object.new; end'
    end

    it_should_behave_like 'a mutator'
  end
end
