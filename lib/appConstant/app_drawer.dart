
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karamtechnology_services/controllers/company_details_Controller.dart';
import 'package:karamtechnology_services/views/company_registration_view.dart';

import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final TextEditingController updateNameController =
  TextEditingController();
final CompanyDetailsController companyDetailsController = Get.find<CompanyDetailsController>();
  static const Color primaryColor = Color(0xFF4527A0);
  static const Color accentColor = Color(0xFF7C4DFF);

  bool isUpdatingName = false;
  bool isLoggingOut = false;

  String get displayName {
    final name =
        authService.value.currentUser?.displayName?.trim() ?? '';
    return name.isNotEmpty ? name : 'User';
  }

  String get email {
    return authService.value.currentUser?.email ?? 'No email available';
  }

  @override
  void dispose() {
    updateNameController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // SNACKBAR
  // --------------------------------------------------

  void showMessage(String message, {bool isError = false}) {
    Get.closeAllSnackbars();

    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
      isError ? Colors.red.shade700 : Colors.green.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  // --------------------------------------------------
  // UPDATE USERNAME
  // --------------------------------------------------

  Future<bool> updatedDisplayName() async {
    if (isUpdatingName) return false;

    final name = updateNameController.text.trim();

    if (name.isEmpty) {
      showMessage(
        'Please enter a username',
        isError: true,
      );
      return false;
    }

    setState(() {
      isUpdatingName = true;
    });

    try {
      await authService.value.updateUserName(userName: name);

      // Reload Firebase user details.
      await authService.value.currentUser?.reload();

      if (!mounted) return false;

      // Refresh the displayed profile.
      setState(() {});

      showMessage('Username updated successfully');

      debugPrint(
        'Updated Display Name: '
            '${authService.value.currentUser?.displayName}',
      );

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Username update error: ${e.message}');

      if (mounted) {
        showMessage(
          e.message ?? 'Username update failed',
          isError: true,
        );
      }

      return false;
    } catch (e) {
      debugPrint('Unexpected username update error: $e');

      if (mounted) {
        showMessage(
          'Something went wrong. Please try again.',
          isError: true,
        );
      }

      return false;
    } finally {
      if (mounted) {
        setState(() {
          isUpdatingName = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // USERNAME DIALOG
  // --------------------------------------------------

  void showUpdateNameDialog() {
    updateNameController.text =
        authService.value.currentUser?.displayName ?? '';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.person_outline, color: accentColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Change Username',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: TextField(
          controller: updateNameController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          maxLength: 50,
          decoration: InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your name',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: accentColor,
                width: 2,
              ),
            ),
          ),
          onSubmitted: (_) => submitUsername(),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: isUpdatingName ? null : () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isUpdatingName ? null : submitUsername,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isUpdatingName
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text('Update'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> submitUsername() async {
    final success = await updatedDisplayName();

    if (!mounted) return;

    if (success && Get.isDialogOpen == true) {
      updateNameController.clear();
     Navigator.pop(context);
    }
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  Future<void> logout() async {
    if (isLoggingOut) return;

    setState(() {
      isLoggingOut = true;
    });

    try {
      await authService.value.signOut();

      debugPrint('Logout completed successfully');

      // Authentication state listener should handle
      // navigation to the sign-in screen.
    } on FirebaseAuthException catch (e) {
      debugPrint('Logout error: ${e.message}');

      if (mounted) {
        showMessage(
          e.message ?? 'Logout failed',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Unexpected logout error: $e');

      if (mounted) {
        showMessage('Unable to logout. Please try again.',
            isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // PROFILE HEADER
  // --------------------------------------------------

  Widget buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 12, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFC501C5),
            Color(0xFF4A0EB6),
            Color(0xFF57A9C2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white70,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Text(
                    displayName.isNotEmpty
                        ? displayName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Service Report User',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Change username',
                onPressed: showUpdateNameDialog,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  // --------------------------------------------------
  // SECTION TITLE
  // --------------------------------------------------

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // SETTINGS TILE
  // --------------------------------------------------

  Widget buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 13,
            ),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF29243A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade500,
                  size: 23,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // LOGOUT BUTTON
  // --------------------------------------------------

  Widget buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: isLoggingOut ? null : logout,
          icon: isLoggingOut
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.red,
            ),
          )
              : const Icon(Icons.logout_rounded),
          label: Text(isLoggingOut ? 'Logging out...' : 'Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red.shade700,
            side: BorderSide(
              color: Colors.red.shade200,
            ),
            backgroundColor: Colors.red.shade50,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // MAIN UI
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.84,
      backgroundColor: const Color(0xFFFCFBFF),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile header
            buildProfileHeader(),

            // Scrollable settings
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildSectionTitle('Account Settings'),

                  buildSettingsTile(
                    icon: Icons.business_outlined,
                    title: 'Company Details',
                    subtitle: 'Update your business information',
                    onTap: () {
                      Get.back();

                      Get.to(
                            () => CompanyRegistrationView(update: true),
                      );
                    },
                  ),

                  buildSettingsTile(
                    icon: Icons.person_outline,
                    title: 'Change Username',
                    subtitle: 'Edit your profile name',
                    onTap: showUpdateNameDialog,
                  ),

                  const SizedBox(height: 12),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: accentColor,
                          size: 21,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Service Report',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 140),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(
                                                                () => Text(
                                companyDetailsController.companyName.value.isEmpty
                                    ? '...'
                                    : companyDetailsController.companyName.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: accentColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ), ),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Fixed bottom area
            const Divider(height: 1),
            buildLogoutButton(),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Obx(()=>Text(
                companyDetailsController.companyName.value.isEmpty ? '...' : companyDetailsController.companyName.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ))
            ),
          ],
        ),
      ),
    );
  }
}
