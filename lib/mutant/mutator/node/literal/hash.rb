module Mutant
  class Mutator
    class Node
      class Literal
        # Mutator for hash literals
        class Hash < self

          handle(:hash)

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
              mutate_child(index)
              dup_children = children.dup
              dup_children.delete_at(index)
              emit_self(*dup_children)
            end
          end

          class Pair < Node

            handle(:pair)

            KEY_INDEX, VALUE_INDEX = 0, 1

          private

            # Perform dispatch
            #
            # @return [undefined]
            #
            # @api private
            #
            def dispatch
              mutate_child(KEY_INDEX)
              mutate_child(VALUE_INDEX)
            end

          end # Pair
        end # Hash
      end # Literal
    end # Node
  end # Mutator
end # Mutant
