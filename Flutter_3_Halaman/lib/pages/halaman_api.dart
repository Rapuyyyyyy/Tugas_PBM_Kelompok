import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanApi extends StatefulWidget {
  const HalamanApi({super.key});

  @override
  State<HalamanApi> createState() => _HalamanApiState();
}

class _HalamanApiState extends State<HalamanApi> {
  List<dynamic> _universitas = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchUniversitas();
  }

  Future<void> fetchUniversitas() async {
    final url = Uri.parse('http://universities.hipolabs.com/search?country=Indonesia');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return; 
        setState(() {
          _universitas = data;
          _loading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _error = 'Gagal memuat data (Kode: ${response.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Terjadi kesalahan: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Daftar Universitas di Indonesia'),
        backgroundColor: Colors.indigo,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _universitas.length,
                  itemBuilder: (context, index) {
                    final univ = _universitas[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(Icons.school, color: Colors.indigo),
                          title: Text(
                            univ['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(univ['web_pages'][0]),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(univ['name']),
                                content: Text('Website: ${univ['web_pages'][0]}'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
