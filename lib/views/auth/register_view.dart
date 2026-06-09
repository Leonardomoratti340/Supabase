import 'package:flutter/material.dart';
import 'package:flutter_supabase/viewmodel/auth_view_model.dart';
import 'package:flutter_supabase/views/auth/login_view.dart';
import 'package:flutter_supabase/views/home_view.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Registrazione"),),
      body: vm.isLoading ? const Center(child: CircularProgressIndicator(),)
      : Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          ElevatedButton(onPressed: ()async{
            await vm.register(emailController.text.trim(), passwordController.text);
            if(vm.session != null && context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeView()));
            }
          }, child: Text("Registarti")),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginView()));
          }, child: const Text("Hai una account? Loggati"))
        ],
      ),
      )
    );
  }
}