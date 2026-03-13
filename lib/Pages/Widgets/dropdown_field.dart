import 'package:flutter/material.dart';

class CustomCategoryPicker extends StatefulWidget {
  final List<String> categories;
  final String? initialValue;
  final Function(String) onSelected;

  const CustomCategoryPicker({
    super.key,
    required this.categories,
    required this.onSelected,
    this.initialValue,
  });

  @override
  State<CustomCategoryPicker> createState() => _CustomCategoryPickerState();
}

class _CustomCategoryPickerState extends State<CustomCategoryPicker> {
  String? _selectedKategori;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: const Color(0xFF1A2A4F),
          ),
          title: Text(
            _selectedKategori ?? "Pilih Kategori",
            style: const TextStyle(
              color: Color(0xFF1A2A4F),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          children: widget.categories.map((cat) => _buildOption(cat)).toList(),
        ),
      ),
    );
  }

  Widget _buildOption(String title) {
    bool isSelected = _selectedKategori == title;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedKategori = title;
        });
        widget.onSelected(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF007BFF) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            // Indikator bulat biru (Radio Button style)
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF007BFF) : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007BFF),
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}