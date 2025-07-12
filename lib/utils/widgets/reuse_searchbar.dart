// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:newsapp/config/colors.dart';

import 'package:remixicon/remixicon.dart';


class SearchBarComman extends StatefulWidget {
  final String searchHintText;
  final TextEditingController searchController;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;

  const SearchBarComman({
    super.key,
    required this.searchHintText,
    required this.searchController,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  State<SearchBarComman> createState() => _SearchBarCommanState();
}

class _SearchBarCommanState extends State<SearchBarComman> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        prefixIcon: Icon(Remix.search_2_line),
        suffixIcon: widget.searchController.text.isNotEmpty
            ? GestureDetector(
          onTap: () {
            widget.searchController.clear();
            widget.onChanged?.call('');
          },
          child: Icon(Remix.close_circle_fill),
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.grey, // Default border color
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.red, // Active border color
            width: 1,
          ),
        ),
        hintText: widget.searchHintText,
        hintStyle: TextStyle(
          color: AppColors.greyColor,
          fontSize: 16,
          fontFamily: "Poppins-Regular",
          fontWeight: FontWeight.normal,
        ),
      ),
      controller: widget.searchController,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: TextInputAction.search,
    );
  }
}