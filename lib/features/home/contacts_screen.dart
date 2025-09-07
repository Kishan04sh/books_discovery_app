
import 'package:auto_route/annotations.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../providers/contactsControllers.dart';

/// ********************* /// Provider /// *********************
final contactsProvider =
StateNotifierProvider<ContactsViewModel, ContactsState>(
        (ref) => ContactsViewModel());

@RoutePage()
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final TextEditingController searchController = TextEditingController();

  /// ****************************************************************

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(contactsProvider.notifier).fetchContacts());
  }


  /// **********************************************************
  void showContactDetails(Contact contact) {
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (user != null)
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(user.displayName ?? "Current User",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(user.email ?? "",
                      style: const TextStyle(color: Colors.grey)),
                ),
              if (user != null) const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.person, color: AppColors.primary),
                title: Text(contact.displayName ?? "Unknown",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (contact.phones != null && contact.phones!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.phone, color: AppColors.primary),
                  title: Text(contact.phones!.first.value ?? "",
                      style: const TextStyle(fontSize: 15)),
                ),
              if (contact.emails != null && contact.emails!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.email, color: AppColors.primary),
                  title: Text(contact.emails!.first.value ?? "",
                      style: const TextStyle(fontSize: 15)),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// ******************************************************************

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactsProvider);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Contacts",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),

            CircleAvatar(
              backgroundColor:AppColors.primary,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ],
        ),
        elevation: 2,
      ),


 /// ****************************************************
      body: state.isLoading
          ? const Center(
          child: CircularProgressIndicator(color: AppColors.primary))
          : state.error.isNotEmpty
          ? Center(child: Text(state.error))
          : Column(
        children: [

 /// ************************************* Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) => ref
                  .read(contactsProvider.notifier)
                  .filterContacts(value),
              decoration: InputDecoration(
                hintText: "Search contacts",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),

 /// ************************************************ Contacts List
          Expanded(
            child: state.filteredContacts.isEmpty
                ? const Center(
                child: Text("No contacts found", style: TextStyle(
                        color: Colors.grey, fontSize: 16)))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: state.filteredContacts.length,
              separatorBuilder: (context, index) =>
              const Divider(height: 1),
              itemBuilder: (context, index) {
                final contact = state.filteredContacts[index];
                return ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 4),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (contact.initials() ?? "?")
                          .toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  title: Text(contact.displayName ?? "Unknown",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: contact.phones != null &&
                      contact.phones!.isNotEmpty
                      ? Text(contact.phones!.first.value ?? "",
                      style: const TextStyle(
                          color: Colors.grey))
                      : null,
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                  onTap: () => showContactDetails(contact),
                );
              },
            ),
          ),

 /// *****************************************************************

        ],
      ),
    );
  }
}
