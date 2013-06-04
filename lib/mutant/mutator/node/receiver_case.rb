module Mutant
  class Mutator
    class Node

      # Mutator for case nodes
      class ReceiverCase < self

        handle(:case)

      private

        # Emit mutations
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit_attribute_mutations(:receiver)
          emit_when_branch_presence_mutations
          emit_else_branch_presence_mutation
          emit_when_branch_mutations
        end

        # Emit else branch presence mutation
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_else_branch_presence_mutation
          emit_self(receiver, when_branches, nil)
        end

        # Emit when branch body mutations
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_when_branch_mutations
          when_branches.each_with_index do |branch, index|
            Mutator.each(branch) do |mutant|
              branches = dup_when_branches
              branches[index]=mutant
              emit_self(receiver, branches, else_branch)
            end
          end
        end

        # Emit when branch presence mutations
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_when_branch_presence_mutations
          return if one?
          when_branches.each_index do |index|
            dup_branches = dup_when_branches
            dup_branches.delete_at(index)
            emit_self(receiver, dup_branches, else_branch)
          end
        end

        # Check for case there is only one when branch
        #
        # @return [true]
        #   returns true when there is only one when branch
        #
        # @return [false]
        #   returns false otherwise
        #
        # @api private
        #
        def one?
          when_branches.one?
        end

        # Return duplicate of when branches
        #
        # @return [Array]
        #
        # @api private
        #
        def dup_when_branches
          when_branches.dup
        end

        # Return when branches
        #
        # @return [Array]
        #
        # @api private
        #
        def when_branches
          node.whens
        end

        # Return receiver
        #
        # @return [Parser::AST::Node]
        #
        # @api private
        #
        def receiver
          node.receiver
        end

        # Return else branch
        #
        # @return [Parser::AST::Node]
        #
        # @api private
        #
        def else_branch
          node.else
        end

      end # ReceiverCase
    end # Node
  end # Mutator
end # Mutant
