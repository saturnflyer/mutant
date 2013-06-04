module Mutant
  # Generator for mutations
  class Mutator
    # Abstract base class for node mutators
    class Node < self
      include AbstractType, NodeHelpers

      # Return identity of node
      #
      # @param [Parser::AST::Node] node
      #
      # @return [String]
      #
      # @api private
      #
      def self.identity(node)
        Unparser.unparse(node)
      end

    private

      # Return mutated node
      #
      # @return [Parser::AST::Node]
      #
      # @api private
      #
      alias_method :node, :input

      # Return duplicated node
      #
      # @return [Parser::AST::Node]
      #
      # @api private
      #
      alias_method :dup_node, :dup_input

      # Return children
      #
      # @return [Array<Parser::AST::Node>]
      #
      # @api private
      #
      def children
        node.children
      end

      # Dispatch on child index
      #
      # @param [Fixnum] index
      #
      # @return [undefined]
      #
      # @api private
      #
      def mutate_child(index, mutator = Mutator)
        children = node.children
        child = children[index]
        mutator.each(child) do |mutation|
          emit_child_update(index, mutation)
        end
      end

      # Emit updated child
      #
      # @param [Fixnum] index
      # @param [Object] update
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_child_update(index, update)
        new_children = children.dup
        new_children[index]=update
        emit_self(new_children)
      end

      # Emit a new AST node with same class as wrapped node
      #
      # @param [Array<Parser::AST::Node>] children
      #
      # @api private
      #
      def emit_self(children)
        emit(Parser::AST::Node.new(node.type, children))
      end

      # Emit a new AST node with NilLiteral class
      #
      # @return [Rubinius::AST::NilLiteral]
      #
      # @api private
      #
      def emit_nil
        emit(s(:nil))
      end

    end # Node
  end # Mutator
end # Mutant
