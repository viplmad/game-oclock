import 'query_builder_options.dart';
import 'validator.dart';
import 'util.dart';

enum ExpressionType { AND, OR }

/// SQL expression builder.
/// A new expression should be created using new Expression() call.
///

class ExpressionNode {
  ExpressionNode();

  ExpressionNode.fromTypeExprParam(
      ExpressionType type, String? expr, Object? param) {
    this.type = type;
    this.expr = expr;
    this.param = param;
  }

  ExpressionNode.fromTypeParent(ExpressionType type, ExpressionNode parent) {
    this.type = type;
    this.parent = parent;
  }
  late ExpressionType type;
  late String? expr;
  late Object? param;
  late ExpressionNode parent;
  List<ExpressionNode> nodes = <ExpressionNode>[];
}

class Expression {
  Expression(QueryBuilderOptions? options) {
    this.options = options ?? QueryBuilderOptions();
    this.tree = ExpressionNode();
    this.current = ExpressionNode();
  }

  late QueryBuilderOptions options;
  late ExpressionNode tree;
  late ExpressionNode current;

  /// Begin AND nested expression.
  /// @return Expression
  Expression andBegin() {
    return doBegin(ExpressionType.AND);
  }

  /// Begin OR nested expression.
  /// @return Expression
  Expression orBegin() {
    return doBegin(ExpressionType.OR);
  }

  /// End the current compound expression.
  /// @return Expression
  Expression end() {
    current = current.parent;
    return this;
  }

  /// Combine the current expression with the given expression using the intersection operator (AND).
  /// @param expr Expression to combine with.
  /// @return Expression
  Expression and(String expr) {
    return andWithParam(expr, null);
  }

  /// Combine the current expression with the given expression using the intersection operator (AND).
  /// @param expr Expression to combine with.
  /// @param param Value to substitute.
  /// @param <P> Number|String|Boolean|QueryBuilder|Expression|Array|Iterable
  /// @return Expression
  Expression andWithParam(String expr, dynamic param) {
    final ExpressionNode newNode =
        ExpressionNode.fromTypeExprParam(ExpressionType.AND, expr, param);
    current.nodes.add(newNode);
    return this;
  }

  /// Combine the current expression with the given expression using the union operator (OR).
  /// @param expr Expression to combine with.
  /// @return Expression
  Expression or(String expr) {
    return orFromExprParam(expr, null);
  }

  /// Combine the current expression with the given expression using the union operator (OR).
  /// @param expr Expression to combine with.
  /// @param param Value to substitute.
  /// @param <P> Number|String|Boolean|QueryBuilder|Expression|Array|Iterable
  /// @return Expression
  Expression orFromExprParam(String expr, dynamic param) {
    final ExpressionNode newNode =
        ExpressionNode.fromTypeExprParam(ExpressionType.OR, expr, param);
    current.nodes.add(newNode);
    return this;
  }

  /// Get the Expression string.
  /// @return A String representation of the expression.
  @override
  String toString() {
    return doString(tree);
  }

  /// Begin a nested expression
  /// @param op Operator to combine with the current expression
  /// @return Expression
  Expression doBegin(ExpressionType op) {
    final ExpressionNode newTree = ExpressionNode.fromTypeParent(op, current);
    current.nodes.add(newTree);
    current = newTree;
    return this;
  }

  /// Get a string representation of the given expression tree node.
  /// @param node Node to
  /// @return String
  String doString(ExpressionNode node) {
    final StringBuffer sb = StringBuffer();
    String nodeStr;
    for (final ExpressionNode child in node.nodes) {
      if (child.expr != null) {
        nodeStr = child.expr!
            .replaceAll('?', Validator.formatValue(child.param, options));
      } else {
        nodeStr = doString(child);

        // wrap nested expressions in brackets
        if (nodeStr.isNotEmpty) {
          nodeStr = '($nodeStr)';
        }
      }

      if (nodeStr.isNotEmpty) {
        if (sb.length > 0) {
          sb.write(' ');
          sb.write(child.type);
          sb.write(' ');
        }
        sb.write(nodeStr);
      }
    }
    return sb.toString();
  }
}
