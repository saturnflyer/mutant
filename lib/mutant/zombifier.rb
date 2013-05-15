module Mutant
  class Zombifier
    # A specific file of a zombified project
    class File
      include Adamantium::Flat, Concord.new(:project, :path)

      NAMESPACE = 'module Zombie; end'.to_ast.freeze

      # Reinsert with differend name
      #
      # @return [self]
      #
      # @api private
      #
      def zombify_root
        root = NAMESPACE.dup
        root.body = namespace_node.body
        ::Mutant::Loader::Eval.run(root, subject)
        self
      end

      # Reinset into wrapped zombie wrapped namespace
      #
      # @return [self]
      #
      # @api private
      #
      def zombify_wrap
        root = NAMESPACE.dup
        root.body = namespace_node
        ::Mutant::Loader::Eval.run(root, subject)
        self
      end

    private

      # Return subject
      #
      # @return [Subject]
      #
      # @api private
      #
      def subject
        Subject.new(path, 1)
      end
      memoize :subject

      # Return namespace node
      #
      # @return [Rubinius::AST::Node]
      #   if found
      #
      # @raise [RuntimeError]
      #   otherwise
      #
      # @api private
      #
      def namespace_node
        root = self.root
        return root if is_namespace_node?(root)

        unless root.kind_of?(Rubinius::AST::Block)
          raise "Cannot walk: #{root.class}"
        end

        root.array.each do |node|
          return node if is_namespace_node?(node)
        end

        raise "Cannot find namespace node in: #{path}"
      end
      memoize :namespace_node

      # Test if node is namespace node
      #
      # @param [Rubinius::AST::Node] node
      #
      # @return [true]
      #   if true
      # 
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def is_namespace_node?(node)
        (
          node.kind_of?(Rubinius::AST::Class) || 
          node.kind_of?(Rubinius::AST::Module)
        ) && node.name == project.namespace_name
      end
       
      # Return root
      #
      # @return [Rubinius::AST::Node]
      #
      # @api private
      #
      def root
        File.read(path).to_ast
      end
      memoize :root
    end

    # A project / library about to being zombiefied
    class Project
      include Adamantium::Flat, Concord.new(:namespace)

      # Return expand filename
      #
      # @param [String] filename
      #
      # @return [Pathname]
      #   if found
      #
      # @raise [RuntimeError]
      #   otherwise
      #
      # @api private
      #
      def self.expand_filename(filename)
        rb_name = "#{filename}.rb"
        $LOAD_PATH.each do |directory|
          path = Pathname.join(directory, rb_name)
          return path if path.exist?
        end
        raise "Unable to find the root file for: #{filename}"
      end

    private

      # Return files of project
      #
      # @return [Enumerable<File>]
      #
      # @api private
      #
      def files
        require_nodes.map do |node|
          arguments = node.arguments.array
          raise unless arguments.one?
          argument = arguments.first
          raise unless argument.class == Rubinius::AST::StringLiteral
          argument.string
        end.select do |file|
          File.new(self.class.expand_file(file.starts_with?(library_name)))
        end << root_file
      end

      # Return require nodes
      #
      # @return [Enumerable<Rubinius::AST::Node]
      #
      # @api private
      #
      def require_nodes
        return [] unless root_file.respond_to?(:array)
        root_file.node.array.select do |node|
          node.class          == Rubinius::AST::SendWithArguments &&
          node.receiver.class == Rubinius::AST::Self              &&
          node.name           == :require
        end
      end

      # Return root file
      #
      # @return [File]
      #
      # @api private
      #
      def root_file
        File.new(self.class.expand_file(library_name))
      end

      # Return library name
      #
      # @return [String]
      #
      # @api private
      #
      def library_name
        Inflecto.underscore(namespace_name)
      end
      memoize :library_name
    end

    # Setup zombie
    #
    # @return [self]
    #
    # @api private
    #
    def self.setup
      files.each do |path|
        path = "#{File.expand_path(path, root)}.rb"
        ast = File.read(path).to_ast
        zombify(ast, path)
      end

      self
    end

    # Return library root directory
    #
    # @return [String]
    #
    # @api private
    #
    def self.root
      File.expand_path('../../../lib',__FILE__)
    end
    private_class_method :root

    # Zombie subject
    class Subject
      include Concord.new(:path, :line)
    end

    # Replace Mutant with Zombie namespace
    #
    # @param [Rubinius::AST::Node]
    #
    # @api private
    #
    # @return [undefined]
    #
    def self.zombify(root, path)
    end
    private_class_method :zombify

    # Find mutant module in AST
    #
    # @param [Rubinius::AST::Node]
    #
    # @return [Rubinius::AST::Node]
    #
    def self.find_mutant(root)
      if is_mutant?(root)
        return root
      end

      unless root.kind_of?(Rubinius::AST::Block)
        raise "Cannot find mutant in: #{root.class}"
      end

      root.array.each do |node|
        return node if is_mutant?(node)
      end

      nil
    end
    private_class_method :find_mutant

    # Test if node is mutant module
    #
    # @param [Rubinius::AST::Node]
    #
    # @return [true]
    #   returns true if node is the mutant module
    #
    # @return [false]
    #   returns false otherwise
    #
    # @api private
    #
    def self.is_mutant?(node)
      node.kind_of?(Rubinius::AST::Module) && is_mutant_name?(node.name)
    end
    private_class_method :is_mutant?

    # Test if node is mutant module name
    #
    # @param [Rubinius::AST::ModuleName]
    #
    # @return [true]
    #   returns true if node is the mutant module name
    #
    # @return [false]
    #   returns false otherwise
    #
    # @api private
    #
    def self.is_mutant_name?(node)
      node.name == :Mutant
    end
    private_class_method :is_mutant_name?

  end
end
