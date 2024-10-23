enum NameType { firstName, lastName }

class ValidationService {
  // name validator
  static String isValidName(String name, NameType nameType) {
    if (name.isEmpty) {
      return nameType == NameType.firstName
          ? 'First Name\nis required.'
          : 'Last Name\nis required.';
    }
    // Check if the name contains only letters and spaces
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    if (!nameRegExp.hasMatch(name)) {
      return "Name can contain only\nletters.";
    }

    // Name is valid
    return 'valid';
  }

  static String isValidString(String key, String value) {
    if (value.isEmpty) {
      return '$key is required.';
    }

    // Check if the name contains only letters and spaces
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    if (!nameRegExp.hasMatch(value)) {
      return "$key can contain only\nletters.";
    }

    return 'valid';
  }

  static String isValidOTP(String key, String value) {
    if (value.isEmpty) {
      return '$key is required.';
    }

    final RegExp numberRegExp = RegExp(r'^[0-9]+$');
    if (!numberRegExp.hasMatch(value)) {
      return "$key can contain only\nnumbers.";
    }

    return 'valid';
  }

  static String isValidNIC(String value) {
    if (value.isEmpty) {
      return 'NIC is required.';
    }

    final oldFormatRegex = RegExp(r'^\d{9}[VvXx]$');
    final newFormatRegex = RegExp(r'^\d{12}$');
    if (oldFormatRegex.hasMatch(value)) {
      return 'valid';
    }
    if (newFormatRegex.hasMatch(value)) {
      return 'valid';
    }

    return 'Invalid NIC format. Please try again';
  }

  // Validate phone number
  static bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^[0-9]{9}$');
    return regex.hasMatch(phoneNumber);
  }

  // Validate password and return an error message if invalid
  static String isValidPassword(String password) {
    if (password.isEmpty) {
      return 'Password is\nrequired.';
    }
    // At least 8 characters long
    if (password.length < 8) {
      return 'Password must be at least\n8 characters long.';
    }

    // Check for at least 1 upper case letter
    RegExp upperCaseRegex = RegExp(r'[A-Z]');
    if (!upperCaseRegex.hasMatch(password)) {
      return 'Password must contain at least\none uppercase letter.';
    }

    // Check for at least 1 lower case letter
    RegExp lowerCaseRegex = RegExp(r'[a-z]');
    if (!lowerCaseRegex.hasMatch(password)) {
      return 'Password must contain at least\none lowercase letter.';
    }

    // At least 1 number
    RegExp numberRegex = RegExp(r'[0-9]');
    if (!numberRegex.hasMatch(password)) {
      return 'Password must contain at least one number.';
    }

    // At least 1 symbol
    RegExp symbolRegex = RegExp(r'[\W]');
    if (!symbolRegex.hasMatch(password)) {
      return 'Password must contain at least one symbol.';
    }

    // Password is valid
    return 'valid';
  }

  // confirm pass validator
  static String isValidConfirmPassword(String password, String conPassword) {
    if (conPassword.isEmpty) {
      return 'Confirm Password\nis required.';
    }

    if (password.toString().trim() != conPassword.toString().trim()) {
      return 'Passwords do not\nmatch.';
    }

    //is valid
    return 'valid';
  }

  // email validator
  static String isValidEmail(String email) {
    if (email.isEmpty) {
      return 'Email\nis required.';
    }

    // Add your custom email validation logic here
    // For a simple example, checking if it contains '@'
    if (!email.contains('@') || !email.contains('.com')) {
      return 'Enter a valid\nemail address.';
    }

    // Email is valid
    return 'valid';
  }

  static String isValidDateOfBirth(String dob) {
    if (dob.isEmpty) {
      return 'Date of Birth\nis required.';
    }

    // Split the input at 'T' to separate date and time
    String datePart = dob.split('T').first;

    // Parse the date
    List<int?> dateParts = datePart.split('-').map(int.tryParse).toList();

    // Check if the date parts are valid integers and not null
    if (dateParts.contains(null) || dateParts.length < 3) {
      return 'Invalid Date of Birth format.';
    }

    // Extract year, month, and day from parsed parts
    int year = dateParts[0]!;
    int month = dateParts[1]!;
    int day = dateParts[2]!;

    // Check if the date is not in the future
    final DateTime currentDate = DateTime.now();
    final DateTime inputDate = DateTime(year, month, day);

    if (inputDate.isAfter(currentDate)) {
      return 'Date of Birth\ncannot be a future date.';
    }

    // Date of Birth is valid
    return 'valid';
  }

  String formatPrice(double price) {
    String formattedPrice = price.toStringAsFixed(2); // 2 decimal places
    List<String> parts = formattedPrice.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "00";

    String integerFormatted = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return 'LKR $integerFormatted.$decimalPart';
  }
  String formatPriceWithCurrency(double price, String currency) {
    String formattedPrice = price.toStringAsFixed(2); // 2 decimal places
    List<String> parts = formattedPrice.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "00";

    String integerFormatted = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return '$currency $integerFormatted.$decimalPart';
  }
}
