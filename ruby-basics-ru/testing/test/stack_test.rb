# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def setup
    @stack = Stack.new [1, 2, 3]
  end

  def test_push_adds_element_on_the_stack
    elem = 4
    @stack.push! elem

    assert { @stack.to_a.last == elem }
  end

  def test_pop_deletes_element_from_the_stack
    assert { @stack.to_a.last == @stack.pop! }
  end

  def test_clear_makes_stack_empty
    assert { @stack.clear!.empty? }
  end

  def test_empty_works_correctly
    assert { !@stack.empty? }

    @stack.clear!
    assert { @stack.empty? }
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
