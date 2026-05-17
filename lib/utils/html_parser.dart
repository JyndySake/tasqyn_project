import 'package:html/parser.dart' as html;

class HtmlParser {
  static List<Map<String, String>> extractPlanLinks(String htmlContent) {
    final document = html.parse(htmlContent);
    final List<Map<String, String>> planLinks = [];
    
    // Find all elements with plan-link class or data attributes
    final planLinkElements = document.querySelectorAll('[class*="plan-link"], [data-plan-link], [data-plan]');
    
    for (final element in planLinkElements) {
      final Map<String, String> linkData = {};
      
      // Extract href if it's an anchor tag
      if (element.localName == 'a') {
        linkData['href'] = element.attributes['href'] ?? '';
      }
      
      // Extract text content
      linkData['text'] = element.text.trim();
      
      // Extract all data attributes
      element.attributes.forEach((key, value) {
        if (key is String && key.startsWith('data-')) {
          linkData[key] = value.toString();
        }
      });
      
      // Extract class
      linkData['class'] = element.attributes['class'] ?? '';
      
      // Extract id
      linkData['id'] = element.attributes['id'] ?? '';
      
      planLinks.add(linkData);
    }
    
    return planLinks;
  }
  
  static List<String> extractAllHrefs(String htmlContent) {
    final document = html.parse(htmlContent);
    final List<String> hrefs = [];
    
    final anchorTags = document.querySelectorAll('a[href]');
    for (final anchor in anchorTags) {
      final href = anchor.attributes['href'];
      if (href != null && href.isNotEmpty) {
        hrefs.add(href);
      }
    }
    
    return hrefs;
  }
  
  static List<Map<String, String>> extractKundelikLinks(String htmlContent) {
    final document = html.parse(htmlContent);
    final List<Map<String, String>> kundelikLinks = [];
    
    // Find all links to kundelik.kz domains
    final anchorTags = document.querySelectorAll('a[href]');
    for (final anchor in anchorTags) {
      final href = anchor.attributes['href'];
      if (href != null && (href.contains('kundelik.kz') || href.contains('schools.kundelik.kz'))) {
        kundelikLinks.add({
          'href': href,
          'text': anchor.text.trim(),
          'class': anchor.attributes['class'] ?? '',
          'id': anchor.attributes['id'] ?? '',
        });
      }
    }
    
    return kundelikLinks;
  }
  
  static Map<String, dynamic> parseUrlParameters(String url) {
    final uri = Uri.parse(url);
    return {
      'path': uri.path,
      'queryParameters': uri.queryParameters,
      'fragment': uri.fragment,
      'host': uri.host,
      'scheme': uri.scheme,
    };
  }
}
