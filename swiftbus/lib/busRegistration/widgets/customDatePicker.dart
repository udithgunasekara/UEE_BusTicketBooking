import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class CustomDatePickerField extends StatefulWidget {
  final String labelText;
  final void Function(DateTime?)? onSaved;
  final String? Function(DateTime?)? validator;

  const CustomDatePickerField({
    Key? key,
    required this.labelText,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(_selectedDate);
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.labelText,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                ),
                labelStyle: const TextStyle(
                  color: Color.fromARGB(169, 34, 116, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Colors.orange, width: 4.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 33, 116, 1),
                    width: 3.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 38,
                        0), // Set custom color for the error underline
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color:
                        Colors.orange, // Custom color when focused with error
                    width: 2.0,
                  ),
                ),
                errorStyle: const TextStyle(
                  color: Colors.red, // Custom error text color
                  fontSize: 13, // Adjust the size of the error message
                  fontWeight:
                      FontWeight.bold, // Bold the error message if needed
                ),
              ),
              readOnly: true,
              onTap: () => _pickDate(context),
              onChanged: (_) {
                state.didChange(_selectedDate);
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red, // Custom error text color
                    fontSize: 13, // Adjust the size of the error message
                    fontWeight:FontWeight.bold, 
                  ),
                ),
              ),
          ],
        );
      },
      onSaved: (value) {
        if (widget.onSaved != null) {
          widget.onSaved!(_selectedDate);
        }
      },
    );
  }
}
