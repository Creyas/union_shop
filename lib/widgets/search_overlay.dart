import 'package:flutter/material.dart';

typedef SearchSelect = void Function(String query);

class SearchOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context, {SearchSelect? onSelect}) {
    if (_entry != null) return;
    _entry = OverlayEntry(
      builder: (ctx) => _SearchPanel(
        onClose: hide,
        onSelect: (q) {
          hide();
          onSelect?.call(q);
        },
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _SearchPanel extends StatefulWidget {
  final VoidCallback onClose;
  final SearchSelect onSelect;
  const _SearchPanel({required this.onClose, required this.onSelect});

  @override
  State<_SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<_SearchPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  List<String> _results = [];

  // sample searchable data — replace with real product list or fetch from backend
  static const List<String> _sample = [
    'Union T‑Shirt',
    'Union Hoodie',
    'Union Mug',
    'Union Cap',
    'Union Tote Bag',
    'Union Jacket',
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _anim.forward();
    _focus.requestFocus();
    _ctrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _ctrl.text.trim().toLowerCase();
    setState(() {
      _results = q.isEmpty
          ? []
          : _sample.where((s) => s.toLowerCase().contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // translucent backdrop: tap to close
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                    height: top, color: Colors.black.withOpacity(0.25)),
              ),

              // search container
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              focusNode: _focus,
                              decoration: InputDecoration(
                                hintText: 'Search products, account, orders...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    if (_ctrl.text.isEmpty) {
                                      widget.onClose();
                                    } else {
                                      _ctrl.clear();
                                    }
                                  },
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (q) {
                                if (q.trim().isEmpty) return;
                                widget.onSelect(q.trim());
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                              onPressed: widget.onClose,
                              child: const Text('Cancel')),
                        ],
                      ),

                      // suggestions
                      if (_results.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          constraints: const BoxConstraints(maxHeight: 240),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: _results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final item = _results[i];
                              return ListTile(
                                title: Text(item),
                                onTap: () => widget.onSelect(item),
                              );
                            },
                          ),
                        )
                      else if (_ctrl.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text('No results for "${_ctrl.text}"',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                    ],
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
