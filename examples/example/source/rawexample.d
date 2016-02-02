// A module written to the raw Python/C API.
module rawexample;

import deimos.python.Python;
import std.stdio;
import core.runtime;

static PyTypeObject Base_type;
static PyTypeObject Derived_type;

struct Base_object {
    mixin PyObject_HEAD;
}

struct Derived_object {
    mixin PyObject_HEAD;
}

extern(C)
PyObject* Base_foo(PyObject* self, PyObject* args) {
    writefln("Base.foo");
    return Py_INCREF(Py_None());
}

extern(C)
PyObject* Base_bar(PyObject* self, PyObject* args) {
    writefln("Base.bar");
    return Py_INCREF(Py_None());
}

PyMethodDef[] Base_methods = [
    {"foo", &Base_foo, METH_VARARGS, ""},
    {"bar", &Base_bar, METH_VARARGS, ""},
    {null, null, 0, null}
];

extern(C)
PyObject* Derived_bar(PyObject* self, PyObject* args) {
    writefln("Derived.bar");
    return Py_INCREF(Py_None());
}

PyMethodDef[] Derived_methods = [
    {"bar", &Derived_bar, METH_VARARGS, ""},
    {null, null, 0, null}
];

extern(C)
PyObject* hello(PyObject* self, PyObject* args) {
    writefln("Hello, world!");
    return Py_INCREF(Py_None());
}

PyMethodDef[] example_methods = [
    {"hello", &hello, METH_VARARGS, ""},
    {null, null, 0, null}
];

version(Python_3_0_Or_Later) {
    PyModuleDef rawmodule = {
        // in lieu of PyModuleDef_HEAD_INIT
        m_base: {
            ob_base: {
                ob_refcnt:1,
                ob_type:null,
            },
            m_init:null,
            m_index:0,
            m_copy:null
        },
        m_name: "example",
        m_doc: null,
        m_size: -1,
    };
}

version(Python_3_0_Or_Later) {
    extern(C)
    export PyObject* PyInit_example () {
        rt_init();
        rawmodule.m_methods = example_methods.ptr;
        PyObject* m = PyModule_Create(&rawmodule);

        Py_SET_TYPE(&Base_type, &PyType_Type);
        Base_type.tp_basicsize = Base_object.sizeof;
        Base_type.tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE;
        Base_type.tp_methods = Base_methods.ptr;
        Base_type.tp_name = "example.Base";
        Base_type.tp_new = &PyType_GenericNew;
        PyType_Ready(&Base_type);
        Py_INCREF(cast(PyObject*)&Base_type);
        PyModule_AddObject(m, "Base", cast(PyObject*)&Base_type);

        Py_SET_TYPE(&Derived_type, &PyType_Type);
        Derived_type.tp_basicsize = Derived_object.sizeof;
        Derived_type.tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE;
        Derived_type.tp_methods = Derived_methods.ptr;
        Derived_type.tp_name = "example.Derived";
        Derived_type.tp_new = &PyType_GenericNew;
        Derived_type.tp_base = &Base_type;
        PyType_Ready(&Derived_type);
        Py_INCREF(cast(PyObject*)&Derived_type);
        PyModule_AddObject(m, "Derived", cast(PyObject*)&Derived_type);

        return m;
    }
}else{
    extern(C)
    export void initexample() {
        rt_init();
        PyObject* m = Py_INCREF(Py_InitModule("example", example_methods.ptr));

        Py_SET_TYPE(&Base_type, &PyType_Type);
        Base_type.tp_basicsize = Base_object.sizeof;
        Base_type.tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE;
        Base_type.tp_methods = Base_methods.ptr;
        Base_type.tp_name = "example.Base";
        Base_type.tp_new = &PyType_GenericNew;
        PyType_Ready(&Base_type);
        Py_INCREF(cast(PyObject*)&Base_type);
        PyModule_AddObject(m, "Base", cast(PyObject*)&Base_type);

        Py_SET_TYPE(&Derived_type, &PyType_Type);
        Derived_type.tp_basicsize = Derived_object.sizeof;
        Derived_type.tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE;
        Derived_type.tp_methods = Derived_methods.ptr;
        Derived_type.tp_name = "example.Derived";
        Derived_type.tp_new = &PyType_GenericNew;
        Derived_type.tp_base = &Base_type;
        PyType_Ready(&Derived_type);
        Py_INCREF(cast(PyObject*)&Derived_type);
        PyModule_AddObject(m, "Derived", cast(PyObject*)&Derived_type);
    }
}

