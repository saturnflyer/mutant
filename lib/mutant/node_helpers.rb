module Mutant
  # Mixin for node helpers
  module NodeHelpers

    # Build node
    #
    # @param [Symbol] type
    #
    # @return [Parser::AST::Node]
    #
    # @api private
    #
    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end
    module_function :s


    NAN               = s(:send, s(:float,  0.0), :/, s(:args, s(:float, 0.0)))
    NEGATIVE_INFINITY = s(:send, s(:float, -1.0), :/, s(:args, s(:float, 0.0)))
    INFINITY          = s(:send, s(:float,  1.0), :/, s(:args, s(:float, 0.0)))

  end # NodeHelpers
end # Mutant
