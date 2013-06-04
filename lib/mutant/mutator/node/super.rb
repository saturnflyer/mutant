module Mutant
  class Mutator
    class Node

      # Mutator for super with parantheses
      class Super < self

        handle(:super)

      private

        # Emit mutations
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit_node(:zsuper)
          emit_without_block
          emit_attribute_mutations(:block) if node.block
          emit_attribute_mutations(:arguments)
        end

        # Emit without block mutation
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_without_block
          dup = dup_node
          dup.block = nil
          emit(dup)
        end

      end # Super
    end # Node
  end # Mutator
end # Mutant
