import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class VendorCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const VendorCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppTheme.spacing4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.border, width: 1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: const [AppTheme.shadowSm],
        ),
        child: child,
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool trendUp;
  final Color color;

  const MetricCard({
    Key? key,
    required this.label,
    required this.value,
    this.trend,
    this.trendUp = true,
    this.color = AppTheme.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VendorCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTheme.fontXs,
                fontWeight: AppTheme.fw700,
                color: AppTheme.textMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppTheme.spacing2),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw800,
                color: color,
              ),
            ),
            if (trend != null) ...[
              SizedBox(height: AppTheme.spacing1),
              Text(
                '${trendUp ? '▲' : '▼'} $trend',
                style: TextStyle(
                  fontSize: AppTheme.fontXs,
                  fontWeight: AppTheme.fw600,
                  color: trendUp ? AppTheme.success : AppTheme.danger,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final String status; // 'ok', 'wait', 'bad', 'info'

  const StatusBadge({
    Key? key,
    required this.label,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'ok':
        bgColor = AppTheme.successLight;
        textColor = AppTheme.success;
        break;
      case 'wait':
        bgColor = AppTheme.warningLight;
        textColor = AppTheme.warning;
        break;
      case 'bad':
        bgColor = AppTheme.dangerLight;
        textColor = AppTheme.danger;
        break;
      case 'info':
      default:
        bgColor = AppTheme.primaryLight;
        textColor = AppTheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing2,
        vertical: AppTheme.spacing1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTheme.fontXs,
          fontWeight: AppTheme.fw700,
          color: textColor,
        ),
      ),
    );
  }
}

class VendorTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;

  const VendorTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
  }) : super(key: key);

  @override
  State<VendorTextField> createState() => _VendorTextFieldState();
}

class _VendorTextFieldState extends State<VendorTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: AppTheme.fontSm,
            fontWeight: AppTheme.fw600,
            color: AppTheme.text,
          ),
        ),
        SizedBox(height: AppTheme.spacing2),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () => setState(() => _obscureText = !_obscureText),
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.textMuted,
                    ),
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

class VendorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;

  const VendorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor = AppTheme.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: AppTheme.border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: AppTheme.fontBase,
                  fontWeight: AppTheme.fw700,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}

class VendorOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color borderColor;
  final Color textColor;
  final double width;
  final double height;

  const VendorOutlineButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderColor = AppTheme.primary,
    this.textColor = AppTheme.primary,
    this.width = double.infinity,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDisabled ? AppTheme.border : borderColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: AppTheme.fontBase,
                  fontWeight: AppTheme.fw700,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    Key? key,
    this.message = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing4),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
              SizedBox(height: AppTheme.spacing4),
              Text(
                message,
                style: const TextStyle(
                  fontSize: AppTheme.fontBase,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const ErrorDialog({
    Key? key,
    this.title = 'Error',
    required this.message,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
