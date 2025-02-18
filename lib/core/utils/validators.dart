class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateComplaint(String? value) {
    if (value == null || value.isEmpty) {
      return 'Complaint description is required';
    }
    if (value.length < 10) {
      return 'Complaint must be at least 10 characters long';
    }
    return null;
  }

  static String? validateOrganization(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an organization';
    }
    return null;
  }
}