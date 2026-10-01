import os

web_dir = r'web'
dist_dir = r'web/dist/assets'

js_file = [f for f in os.listdir(dist_dir) if f.endswith('.js')][0]
css_file = [f for f in os.listdir(dist_dir) if f.endswith('.css')][0]

with open(os.path.join(dist_dir, js_file), 'r', encoding='utf-8') as f:
    js_code = f.read()

with open(os.path.join(dist_dir, css_file), 'r', encoding='utf-8') as f:
    css_code = f.read()

# 1. Single-file index.html
single_html = '<!DOCTYPE html>\n<html lang="en">\n<head>\n'
single_html += '  <meta charset="UTF-8" />\n'
single_html += '  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />\n'
single_html += '  <title>Pak Ludo - Classic Board Game</title>\n'
single_html += '  <style>\n' + css_code + '\n  </style>\n</head>\n<body>\n'
single_html += '  <div id="root"></div>\n'
single_html += '  <script type="module">\n' + js_code + '\n  </script>\n</body>\n</html>'

with open(os.path.join(web_dir, 'index.html'), 'w', encoding='utf-8') as f:
    f.write(single_html)

print('Generated single-file index.html (' + str(len(single_html)) + ' bytes)')

# 2. Blogger Widget Embed snippet
embed_html = '<!-- Pak Ludo Blogger Embed Widget -->\n'
embed_html += '<div id="pak-ludo-wrapper" style="width:100%; max-width:960px; margin:0 auto;">\n'
embed_html += '  <div id="root"></div>\n</div>\n'
embed_html += '<style>\n' + css_code + '\n</style>\n'
embed_html += '<script type="module">\n' + js_code + '\n</script>\n'

with open(os.path.join(web_dir, 'blogger-widget-embed.html'), 'w', encoding='utf-8') as f:
    f.write(embed_html)

print('Generated blogger-widget-embed.html')

# 3. Blogger Theme XML based on Original theme XML
orig_theme_path = os.path.join(web_dir, 'Original theme-302384996019425966.xml')
with open(orig_theme_path, 'r', encoding='utf-8') as f:
    theme_xml = f.read()

# CSS injection with complete Blogger chrome hiding rules
css_block = '\n    <style type="text/css">\n/*<![CDATA[*/\n'
css_block += '''
/* Hide all default Blogger UI chrome & widgets (excluding game app elements) */
.bg-photo-overlay,
.bg-photo-container,
.bg-photo,
.centered-top-container,
.centered-top-placeholder,
.centered-top,
.hamburger-menu,
.search,
.search-expand,
.search-input,
.return_link,
header:not(#root header),
footer.footer,
aside,
.sidebar-container,
.sidebar_top,
.sidebar_bottom,
.widget,
.skip-navigation,
#navbar,
#navbar-iframe,
.navbar,
.post-bottom,
.blog-name,
.comment-link,
.comments,
#comments,
.feed-links,
.blog-feeds,
.post-feeds,
#blog-pager,
.item-control,
.profile-link,
.profile-datablock,
.profile-textblock,
.attribution,
.status-msg-wrap,
.blogger-hidden-container {
  display: none !important;
  visibility: hidden !important;
  height: 0 !important;
  width: 0 !important;
  opacity: 0 !important;
  pointer-events: none !important;
  position: absolute !important;
  top: -9999px !important;
  left: -9999px !important;
  margin: 0 !important;
  padding: 0 !important;
  border: none !important;
}

/* Reset page layout to pure 100% clean full-screen game canvas */
html, body {
  margin: 0 !important;
  padding: 0 !important;
  width: 100% !important;
  min-height: 100vh !important;
  background-color: #f8fafc !important;
  background-image: none !important;
  font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
  overflow-x: hidden !important;
}

#root {
  display: flex !important;
  flex-direction: column !important;
  visibility: visible !important;
  width: 100% !important;
  min-height: 100vh !important;
  margin: 0 !important;
  padding: 0 !important;
  opacity: 1 !important;
  pointer-events: auto !important;
  position: relative !important;
  top: 0 !important;
  left: 0 !important;
}

/* Guarantee visibility and interactivity of Pak Ludo App Footer & Links */
#root footer,
#root [class*="appFooter"],
#root [class*="app-footer"] {
  display: flex !important;
  visibility: visible !important;
  opacity: 1 !important;
  pointer-events: auto !important;
  position: relative !important;
  top: auto !important;
  left: auto !important;
  width: 100% !important;
  height: auto !important;
  min-height: 3.5em !important;
  z-index: 99 !important;
}

#root footer a,
#root [class*="footerLink"],
#root [class*="footer-link"] {
  display: inline-block !important;
  visibility: visible !important;
  opacity: 1 !important;
  pointer-events: auto !important;
  position: relative !important;
  cursor: pointer !important;
}
'''
css_block += css_code
css_block += '\n/*]]>*/\n    </style>\n'

# Replace </head> with injected CSS + </head>
theme_xml_mod = theme_xml.replace('</head>', css_block + '  </head>')

# Wrap the body contents in hidden container and place #root as the visible main container
# Find <body>
body_idx = theme_xml_mod.find('<body>')
if body_idx != -1:
    before_body = theme_xml_mod[:body_idx + 6]
    after_body = theme_xml_mod[body_idx + 6:]
    
    # Find </body>
    closing_body_idx = after_body.rfind('</body>')
    body_content = after_body[:closing_body_idx]
    after_closing_body = after_body[closing_body_idx:]
    
    new_body = '\n    <!-- Pak Ludo Game App Root -->'
    new_body += '\n    <div id="root"></div>\n'
    new_body += '\n    <!-- Quarantined Blogger Widgets for XML Schema Compliance -->'
    new_body += '\n    <div class="blogger-hidden-container" style="display:none !important; visibility:hidden !important; height:0 !important; width:0 !important; overflow:hidden !important; position:absolute !important; top:-9999px !important; left:-9999px !important;">'
    new_body += body_content
    new_body += '\n    </div>\n'
    
    # JS injection
    js_block = '\n    <script type="text/javascript">\n//<![CDATA[\n'
    js_block += js_code
    js_block += '\n//]]>\n    </script>\n'
    
    theme_xml_mod = before_body + new_body + js_block + after_closing_body

out_theme_path = os.path.join(web_dir, 'pak-ludo-blogger-theme.xml')
with open(out_theme_path, 'w', encoding='utf-8') as f:
    f.write(theme_xml_mod)

print('Generated pak-ludo-blogger-theme.xml (' + str(len(theme_xml_mod)) + ' bytes)')

