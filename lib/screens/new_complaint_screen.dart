import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/utils/validators.dart';
import '../core/services/complaint_service.dart';

class NewComplaintScreen extends StatefulWidget {
  const NewComplaintScreen({super.key});

  @override
  State<NewComplaintScreen> createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _complaintService = ComplaintService();
  String _selectedCategory = AppConstants.categories[0]['name'];
  String? _selectedOrganization;
  final _descriptionController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedType = 'Complaint';
  final List<String> _submissionTypes = ['Complaint', 'Feedback', 'Compliment'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  // Extended dummy organizations data
  final Map<String, List<String>> _organizationsByCategory = {
    'Banking': [
      'State Bank',
      'National Bank',
      'Reserve Bank',
      'Cooperative Banks',
      'Private Banks'
    ],
    'Government': [
      'Municipal Corporation',
      'Revenue Department',
      'Police Department',
      'Public Works',
      'Social Welfare'
    ],
    'Telecom': [
      'Telecom Authority',
      'Network Providers',
      'Internet Services',
      'Postal Services',
      'Communication Department'
    ],
    'Insurance': [
      'Life Insurance',
      'Health Insurance',
      'General Insurance',
      'Insurance Regulatory',
      'Claims Department'
    ],
    'Healthcare': [
      'Public Hospitals',
      'Medical Council',
      'Health Department',
      'Primary Health Centers',
      'Drug Control Authority'
    ],
    'Education': [
      'School Board',
      'University Grants',
      'Education Department',
      'Technical Education',
      'Research Institutes'
    ],
  };

  List<String> get _currentOrganizations =>
      _organizationsByCategory[_selectedCategory] ?? [];

  @override
  void dispose() {
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New $_selectedType'),
        backgroundColor: _getTypeColor().withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Focus(
                  child: SegmentedButton<String>(
                    segments: _submissionTypes.map((type) => ButtonSegment<String>(
                      value: type,
                      label: Text(type),
                      icon: Icon(_getTypeIcon(type)),
                    )).toList(),
                    selected: {_selectedType},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return _getTypeColor();
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    onSelectionChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value.first;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Focus(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category['name'],
                              child: Row(
                                children: [
                                  Icon(category['icon']),
                                  const SizedBox(width: 8),
                                  Text(category['name']),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _selectedOrganization = null;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Focus(
                  child: DropdownButtonFormField<String>(
                    value: _selectedOrganization,
                    decoration: const InputDecoration(
                      labelText: 'Organization',
                      border: OutlineInputBorder(),
                    ),
                    items: _currentOrganizations
                        .map((org) => DropdownMenuItem<String>(
                              value: org,
                              child: Row(
                                children: [
                                  Icon(Icons.business,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 8),
                                  Text(org),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOrganization = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an organization';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Focus(
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: Validators.validateComplaint,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final formState = _formKey.currentState;
                    if (formState == null) return;
                    
                    if (formState.validate()) {
                      if (_selectedOrganization == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an organization'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      final canSubmit = await _canSubmitComplaint();
                      if (!canSubmit) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'You cannot submit a new $_selectedType in the $_selectedCategory category within 3 days of your last submission'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      try {
                        final complaint = {
                          'type': _selectedType,
                          'category': _selectedCategory,
                          'organization': _selectedOrganization,
                          'description': _descriptionController.text,
                          'date': DateTime.now().toIso8601String(),
                          'status': 'Pending'
                        };
                        
                        await _complaintService.saveComplaint(complaint);
                        
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$_selectedType submitted successfully'),
                            backgroundColor: _getTypeColor(),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to submit $_selectedType: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getTypeColor(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: Text('Submit $_selectedType',
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (_selectedType) {
      case 'Complaint':
        return Colors.red;
      case 'Feedback':
        return Colors.orange;
      case 'Compliment':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Complaint':
        return Icons.warning_rounded;
      case 'Feedback':
        return Icons.feedback_rounded;
      case 'Compliment':
        return Icons.thumb_up_rounded;
      default:
        return Icons.warning_rounded;
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
  Future<bool> _canSubmitComplaint() async {
    // TODO: Replace with actual API call to check complaint history
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulating complaint history check
    final recentComplaints = [
      {
        'category': 'Banking',
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'category': 'Healthcare',
        'date': DateTime.now().subtract(const Duration(days: 4)),
      },
    ];

    final hasRecentComplaint = recentComplaints.any((complaint) =>
        complaint['category'] == _selectedCategory &&
        (complaint['date'] as DateTime).isAfter(
            DateTime.now().subtract(const Duration(days: 3))));

    return !hasRecentComplaint;
  }
}
