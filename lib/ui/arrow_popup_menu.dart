// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A popup menu item with optional keyboard shortcut display
class ArrowPopupMenuItem<T> {
  final T value;
  final Widget child;
  final String? shortcut;
  final bool enabled;
  final VoidCallback? onTap;
  final bool showDividerAfter;

  const ArrowPopupMenuItem({
    required this.value,
    required this.child,
    this.shortcut,
    this.enabled = true,
    this.onTap,
    this.showDividerAfter = false,
  });
}

/// Shows a popup menu with an arrow pointing to the button
Future<T?> showArrowPopupMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<ArrowPopupMenuItem<T>> items,
  double arrowWidth = 20.0,
  double arrowHeight = 10.0,
  Color? backgroundColor,
  double elevation = 8.0,
  ShapeBorder? shape,
}) async {
  final theme = Theme.of(context);
  final effectiveBackgroundColor = backgroundColor ?? theme.scaffoldBackgroundColor;

  return await showGeneralDialog<T>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.01),
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, animation, secondaryAnimation) {
      return _PopupMenuWrapper<T>(
        position: position,
        items: items,
        arrowWidth: arrowWidth,
        arrowHeight: arrowHeight,
        backgroundColor: effectiveBackgroundColor,
        elevation: elevation,
        theme: theme,
      );
    },
  );
}


class _PopupMenuWrapper<T> extends StatefulWidget {
  final RelativeRect position;
  final List<ArrowPopupMenuItem<T>> items;
  final double arrowWidth;
  final double arrowHeight;
  final Color backgroundColor;
  final double elevation;
  final ThemeData theme;

  const _PopupMenuWrapper({
    required this.position,
    required this.items,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.backgroundColor,
    required this.elevation,
    required this.theme,
  });

  @override
  State<_PopupMenuWrapper<T>> createState() => _PopupMenuWrapperState<T>();
}

class _PopupMenuWrapperState<T> extends State<_PopupMenuWrapper<T>> {
  late final FocusScopeNode _scopeNode;

  @override
  void initState() {
    super.initState();
    _scopeNode = FocusScopeNode(debugLabel: 'PopupMenuScope');
    // Request focus on the scope after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scopeNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _scopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.translucent,
      child: FocusScope(
        node: _scopeNode,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Stack(
            children: [
              // Positioned wrapper to place the menu
              Positioned(
                left: widget.position.left,
                top: widget.position.top,
                child: GestureDetector(
                  onTap: () {}, // Prevent tap from closing when clicking menu
                  child: Material(
                    color: Colors.transparent,
                    child: _ArrowPopupMenuWidget<T>(
                      items: widget.items,
                      arrowWidth: widget.arrowWidth,
                      arrowHeight: widget.arrowHeight,
                      backgroundColor: widget.backgroundColor,
                      elevation: widget.elevation,
                      theme: widget.theme,
                      scopeNode: _scopeNode,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowPopupMenuWidget<T> extends StatefulWidget {
  final List<ArrowPopupMenuItem<T>> items;
  final double arrowWidth;
  final double arrowHeight;
  final Color backgroundColor;
  final double elevation;
  final ThemeData theme;
  final FocusScopeNode scopeNode;

  const _ArrowPopupMenuWidget({
    required this.items,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.backgroundColor,
    required this.elevation,
    required this.theme,
    required this.scopeNode,
  });

  @override
  State<_ArrowPopupMenuWidget<T>> createState() => _ArrowPopupMenuWidgetState<T>();
}

class _ArrowPopupMenuWidgetState<T> extends State<_ArrowPopupMenuWidget<T>> {
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    // Create focus nodes for each item
    for (int i = 0; i < widget.items.length; i++) {
      _focusNodes.add(FocusNode(debugLabel: 'MenuItem$i'));
    }
    // Request focus on first enabled item after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFocusOnFirstItem();
    });
  }

  void _requestFocusOnFirstItem() {
    final firstEnabledIndex = widget.items.indexWhere((item) => item.enabled);
    if (firstEnabledIndex != -1 && mounted) {
      // First ensure the scope has focus
      widget.scopeNode.requestFocus();
      // Then request focus on the first item
      Future.microtask(() {
        if (mounted) {
          _focusNodes[firstEnabledIndex].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Menu content with top padding for arrow
        Container(
          margin: EdgeInsets.only(top: widget.arrowHeight),
          child: Material(
            elevation: widget.elevation,
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 50,
                maxWidth: 180,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < widget.items.length; i++) ...[
                    _buildMenuItem(
                      context,
                      widget.items[i],
                      _focusNodes[i],
                      autofocus: i == 0 && widget.items[i].enabled,
                    ),
                    if (widget.items[i].showDividerAfter && i < widget.items.length - 1)
                      Divider(height: 1, thickness: 1, color: widget.theme.dividerColor),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Arrow positioned centered
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: CustomPaint(
              size: Size(widget.arrowWidth, widget.arrowHeight),
              painter: _ArrowPainter(
                color: widget.backgroundColor,
                arrowWidth: widget.arrowWidth,
                arrowHeight: widget.arrowHeight,
                elevation: widget.elevation,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ArrowPopupMenuItem<T> item,
    FocusNode focusNode,
    {bool autofocus = false}
  ) {
    void handleActivate() {
      if (item.enabled) {
        item.onTap?.call();
        Navigator.of(context).pop(item.value);
      }
    }

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (Intent intent) {
              handleActivate();
              return null;
            },
          ),
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            child: Focus(
              focusNode: focusNode,
              autofocus: autofocus,
              canRequestFocus: item.enabled,
              skipTraversal: !item.enabled,
              child: _MenuItemContent(
                item: item,
                theme: widget.theme,
                onActivate: handleActivate,
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItemContent<T> extends StatefulWidget {
  final ArrowPopupMenuItem<T> item;
  final ThemeData theme;
  final VoidCallback onActivate;
  final FocusNode focusNode;

  const _MenuItemContent({
    required this.item,
    required this.theme,
    required this.onActivate,
    required this.focusNode,
  });

  @override
  State<_MenuItemContent<T>> createState() => _MenuItemContentState<T>();
}

class _MenuItemContentState<T> extends State<_MenuItemContent<T>> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Rebuild when focus changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;

    return Container(
      decoration: BoxDecoration(
        color: isFocused
            ? widget.theme.colorScheme.onSurface.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        hoverColor: widget.theme.colorScheme.onSurface.withValues(alpha: 0.08),
        highlightColor: widget.theme.colorScheme.onSurface.withValues(alpha: 0.12),
        splashColor: widget.theme.colorScheme.onSurface.withValues(alpha: 0.12),
        canRequestFocus: false,
        onTap: widget.onActivate,
        onHover: (hovering) {
          if (hovering && widget.item.enabled) {
            widget.focusNode.requestFocus();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: DefaultTextStyle(
                  style: widget.theme.textTheme.bodyMedium!.copyWith(
                    color: widget.item.enabled
                        ? widget.theme.textTheme.bodyMedium!.color
                        : widget.theme.disabledColor,
                  ),
                  child: widget.item.child,
                ),
              ),
              if (widget.item.shortcut != null) ...[
                const SizedBox(width: 24),
                Text(
                  widget.item.shortcut!,
                  style: widget.theme.textTheme.bodySmall!.copyWith(
                    color: widget.item.enabled ? widget.theme.hintColor : widget.theme.disabledColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final double arrowWidth;
  final double arrowHeight;
  final double elevation;

  _ArrowPainter({
    required this.color,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.elevation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw shadow for the arrow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, elevation);

    // Calculate arrow position (centered in the given size)
    final arrowCenter = size.width / 2;

    // Create arrow path
    final arrowPath = Path()
      ..moveTo(arrowCenter - arrowWidth / 2, arrowHeight)
      ..lineTo(arrowCenter, 0)
      ..lineTo(arrowCenter + arrowWidth / 2, arrowHeight)
      ..close();

    // Draw shadow
    canvas.drawPath(arrowPath, shadowPaint);
    
    // Draw arrow
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.arrowWidth != arrowWidth ||
        oldDelegate.arrowHeight != arrowHeight ||
        oldDelegate.elevation != elevation;
  }
}

