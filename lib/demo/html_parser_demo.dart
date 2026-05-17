import 'package:flutter/material.dart';
import '../services/kundelik_service.dart';
import '../utils/html_parser.dart';

class HtmlParserDemo extends StatefulWidget {
  const HtmlParserDemo({Key? key}) : super(key: key);

  @override
  State<HtmlParserDemo> createState() => _HtmlParserDemoState();
}

class _HtmlParserDemoState extends State<HtmlParserDemo> {
  final List<String> _urls = [
    'https://schools.kundelik.kz/v2/reports/default?year=2025&school=1000001220513&datefrom=07.02.2026&dateto=07.02.2026&report=ksp-classteacher&teacher=1000002593966',
    'https://schools.kundelik.kz/v2/journals/?school=1000001220513',
    'https://kundelik.kz/journals/criteriaMarks/group/2384130192876720205/subject/1716611619887448404/period/2388013040880783646',
    'https://schools.kundelik.kz/v2/lesson?school=1000001220513&lesson=2441504754018508579'
  ];
  
  List<Map<String, String>> _planLinks = [];
  List<String> _allHrefs = [];
  List<Map<String, String>> _kundelikLinks = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _analyzeUrls();
  }

  void _analyzeUrls() {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Analyze URL parameters
      for (final url in _urls) {
        final parsed = HtmlParser.parseUrlParameters(url);
        print('URL: $url');
        print('Path: ${parsed['path']}');
        print('Host: ${parsed['host']}');
        print('Query Parameters: ${parsed['queryParameters']}');
        print('---');
      }
    } catch (e) {
      setState(() {
        _error = 'Error analyzing URLs: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAndParseLinks(String url) async {
    setState(() {
      _isLoading = true;
      _error = '';
      _planLinks = [];
      _allHrefs = [];
      _kundelikLinks = [];
    });

    try {
      // Fetch plan links
      final planLinks = await KundelikService.extractPlanLinksFromUrl(url);
      
      // Fetch all hrefs
      final allHrefs = await KundelikService.extractAllHrefsFromUrl(url);
      
      // Fetch kundelik links
      final kundelikLinks = await KundelikService.extractKundelikLinksFromUrl(url);

      setState(() {
        _planLinks = planLinks;
        _allHrefs = allHrefs;
        _kundelikLinks = kundelikLinks;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTML Parser Demo'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.red.shade100,
                      child: Text(
                        'Error: $_error',
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  
                  const Text(
                    'Available URLs:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  ..._urls.map((url) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _fetchAndParseLinks(url),
                      child: Text(
                        'Parse: ${Uri.parse(url).path}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )),
                  
                  const SizedBox(height: 20),
                  
                  if (_planLinks.isNotEmpty) ...[
                    const Text(
                      'Plan Links Found:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._planLinks.map((link) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (link['href']?.isNotEmpty == true)
                              Text('Href: ${link['href']}', 
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (link['text']?.isNotEmpty == true)
                              Text('Text: ${link['text']}'),
                            if (link['class']?.isNotEmpty == true)
                              Text('Class: ${link['class']}'),
                            if (link['id']?.isNotEmpty == true)
                              Text('ID: ${link['id']}'),
                          ],
                        ),
                      ),
                    )),
                  ],
                  
                  if (_kundelikLinks.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Kundelik Links Found:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._kundelikLinks.map((link) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Href: ${link['href']}', 
                                 style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (link['text']?.isNotEmpty == true)
                              Text('Text: ${link['text']}'),
                          ],
                        ),
                      ),
                    )),
                  ],
                  
                  if (_allHrefs.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'All Hrefs (${_allHrefs.length}):',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListView.builder(
                        itemCount: _allHrefs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                            child: Text(
                              _allHrefs[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
