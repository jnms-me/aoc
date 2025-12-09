window.addEventListener("load", function() {
    Scheme.load_main("index.wasm", {
        user_imports: {
            console: {
                log: (msg) => console.log(msg),
            },
            document: {
                body: () => document.body,
                createElement: Document.prototype.createElement.bind(document),
                createTextNode: Document.prototype.createTextNode.bind(document),
                getElementById: Document.prototype.getElementById.bind(document),
            },
            element: {
                addEventListener: (el, event, handler) => el.addEventListener(event, handler),
                appendChild: (el, child) => el.appendChild(child),
                remove: (el) => el.remove(),
                setAttribute: (el, name, value) => el.setAttribute(name, value),
                value: (el) => el.value,
            },
            event: {
                target: (event) => event.target,
            }
        }
    });
});
