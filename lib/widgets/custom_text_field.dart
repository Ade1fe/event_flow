// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String? hintText;
//   final IconData? prefixIcon;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final TextCapitalization textCapitalization;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;
//   final int maxLines;
//   final bool enabled;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.keyboardType,
//     this.textCapitalization = TextCapitalization.none,
//     this.validator,
//     this.onChanged,
//     this.maxLines = 1,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization,
//       validator: validator,
//       onChanged: onChanged,
//       maxLines: maxLines,
//       enabled: enabled,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: hintText,
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: Theme.of(context).colorScheme.surface,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: Colors.grey.shade300,
//             width: 1,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: Theme.of(context).colorScheme.primary,
//             width: 2,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: Theme.of(context).colorScheme.error,
//             width: 2,
//           ),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: Theme.of(context).colorScheme.error,
//             width: 2,
//           ),
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDarkMode
            ? Colors.grey[900]
            : Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // borderSide: BorderSide(color: Colors.grey.shade900, width: 1),
          borderSide: BorderSide(
            color: isDarkMode
                ? (Colors.grey[900] ?? Colors.black)
                : Theme.of(context).colorScheme.surface,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 0.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 0.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 0.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
