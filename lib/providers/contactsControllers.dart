
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';


/// *********************/// State/// *********************

class ContactsState {
  final List<Contact> contacts;
  final List<Contact> filteredContacts;
  final bool isLoading;
  final String error;

  ContactsState({
    required this.contacts,
    required this.filteredContacts,
    required this.isLoading,
    required this.error,
  });

  ContactsState copyWith({
    List<Contact>? contacts,
    List<Contact>? filteredContacts,
    bool? isLoading,
    String? error,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// *********************/// ViewModel/// *********************

class ContactsViewModel extends StateNotifier<ContactsState> {
  ContactsViewModel()
      : super(ContactsState(
      contacts: [], filteredContacts: [], isLoading: true, error: ''));

  /// Request permission and fetch contacts
  Future<void> fetchContacts() async {
    state = state.copyWith(isLoading: true, error: '');

    final status = await Permission.contacts.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      final result = await Permission.contacts.request();
      if (!result.isGranted) {
        state = state.copyWith(isLoading: false, error: 'Contacts permission denied');
        openAppSettings();
        return;
      }
    }


    try {
      final Iterable<Contact> _contacts = await ContactsService.getContacts();
      final contactsList = _contacts.toList();
      state = state.copyWith(
          contacts: contactsList,
          filteredContacts: contactsList,
          isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Failed to fetch contacts');
    }
  }

  /// Filter contacts by search query
  void filterContacts(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredContacts: state.contacts);
    } else {
      state = state.copyWith(
          filteredContacts: state.contacts
              .where((c) =>
          c.displayName != null &&
              c.displayName!.toLowerCase().contains(query.toLowerCase()))
              .toList());
    }
  }
}