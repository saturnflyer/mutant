module Mutant
  class Mutator
    class Node
      class Literal < self
        # Mutator for array literals
        class Array < self

          handle(:array)

        private

          # Emit mutations
          #
          # @return [undefined]
          #
          # @api private
          #
          def dispatch
            emit_nil
            emit_self
            children.each_index do |index|
              dup_children = children.dup
              dup_children.delete_at(index)
              emit_self(*dup_children)
              mutate_child(index)
            end
            emit_self(s(:nil), *children)
          end

        end # Array
      end # Literal
    end # Node
  end # Mutator
end # Mutant
