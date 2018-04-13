EngineStore.screen.app_components += %w{beach_api_core/screens/components}
EngineStore.screen.active_admin_components += %w{beach_api_core/active_admin/screens/components}
EngineStore.screen.app_js_pathes += %w{screens/components}
EngineStore.screen.app_css_pathes += ["screens/app"]
EngineStore.screen.active_admin_js_pathes += ["active_admin/screens/app"]
EngineStore.screen.active_admin_css_pathes += ["active_admin/screens/app"]
EngineStore.screen.body_controls(Hash.new).merge!({ content: ["html", "metrics", "card", "items-in-a-row", 'combination-control'],
                                                    forms:   ["checkbox-list", "radio-list", "input", "button", "select"],
                                                    "graphical-elements": ["video", "image"],
                                                    "data-visualization": ["chart"] })
EngineStore.screen.footer_controls(Hash.new).merge!({ forms: ['button', 'input', 'select'] })

