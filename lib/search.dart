import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool _isOpen = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isOpen) {
                  setState(() {
                    _isOpen= !isOpen;
                  });
                },
                children: [
                  ExpansionPanel(
                    body: Column(
                      
                      children: [
                        CheckboxListTile(
                          title: const Text('No Kids Zone'),
                          value: isChecked1,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked1 = value!;
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: const Text('Pet-Friendly'),
                          value: isChecked2,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked2 = value!;
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: const Text('Free breakfast'),
                          value: isChecked3,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked3 = value!;
                            });
                          }
                        ),
                      ] 
                    ),
                    
                    isExpanded: _isOpen,
                    headerBuilder:(context, isExpanded) {
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              
                            ),
                            
                          ),
                          
                          const SizedBox(width: 20),
                          const Text(
                            'select filters',
                          )
                        ],
                      );
                    }
                  )
                ]
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        
                      ),
                      const SizedBox(width: 20,),
                      Text(_selectedDate == null
                            ? ' '
                            : 'Check-In: ${_selectedDate?.year}년 ${_selectedDate?.month}월 ${_selectedDate?.day}일'
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    
                    onPressed: () => _selectDate(context),
                    child: const Text('select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Please check your choice'),
                  content: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.checklist,
                            size: 30,
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isChecked1? 'No Kids Zone / ' : ' '
                              ),
                              Text(
                                isChecked2? 'Pet-Friendly / ' : ' '
                              ),
                              Text(
                                isChecked3? 'Free breakfast / ' : ' '
                              ),
                            ],
                          ),
                        ], 
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 30,
                          ),
                          const SizedBox(width: 10,),
                          const Text(
                            'IN',
                            style: TextStyle(
                              fontWeight:FontWeight.bold,
                            ),
                            
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            _selectedDate == null
                            ? ' '
                            : '${_selectedDate?.year}년 ${_selectedDate?.month}월 ${_selectedDate?.day}일'
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Search');
                        _selectDate(context);
                      },
                      child: const Text('Search'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
              child: const Text('Search'),
            ),


            ]
          ),
        ),
      ), 
      
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
}