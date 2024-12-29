import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'component.dart';
import 'component_widget.dart';
import 'style_element.dart';

import 'layout_model.dart';

class ComponentRadioWidget extends ComponentWidget {
  const ComponentRadioWidget(super.component, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context) {
    String text = component['source']?.isNotEmpty ?? false
        ? '\$' + component['source']
        : '';
    if (text.isEmpty) {
      text = component['text'] ?? '';
    }

    var style = layoutModel.getStyleElementById(component['style'].id) ??
        StyleElement('стиль');

    return Container(
      alignment: component['alignment'],
      child: CustomRadioButton(component: component,),
    );
  }
}
class CustomRadioButton extends StatefulWidget {
  final LayoutComponent component;

  const CustomRadioButton(
      {super.key, required this.component,});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  void handleRadioValueChanged(String? value) {
    setState(() {
      widget.component.properties['source']?.value =
      widget.component.properties['source']?.value == value
          ? 'none'
          : value ?? 'none';
    });
  }

  late List<String> options;
  String currentOption = 'none';

  @override
  void initState() {
    options = ['Исправно', 'Неисправно'];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SizedBox(
            height: widget.component['size'].height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => handleRadioValueChanged(options[0]),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Radio(
                            key: UniqueKey(),
                            toggleable: true,
                            value: options[0],
                            groupValue: widget.component.properties['source']?.value
                                .toString(),
                            onChanged: handleRadioValueChanged,
                          ),
                        ),
                        Text(
                          options[0],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 199, 136),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const VerticalDivider(),
                Expanded(
                  child: InkWell(
                    onTap: () => handleRadioValueChanged(options[1]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          options[1],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 173, 74, 197),
                          ),
                        ),
                        // const Spacer(),
                        Transform.scale(
                          scale: 1.2,
                          child: Radio(
                            key: UniqueKey(),
                            toggleable: true,
                            fillColor: MaterialStateColor.resolveWith(
                                  (states) => const Color.fromARGB(255, 173, 74, 197),
                            ),
                            value: options[1],
                            groupValue: widget.component.properties['source']?.value
                                .toString(),
                            onChanged: handleRadioValueChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool? setBooleanValue(String? value) {
    switch (value) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return null;
    }
  }
}