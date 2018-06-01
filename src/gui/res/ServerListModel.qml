import QtQuick 2.0

ListModel {
    id: server_model
    ListElement {
        name: "long server name"
        ip: "192.168.1.101"
        locked: true
        numUsers: 13
    }
    ListElement {
        name: "Jeff"
        ip: "192.168.1.102"
        locked: false
        numUsers: 8
    }
    ListElement {
        name: "Raul"
        ip: "192.168.1.103"
        locked: true
        numUsers: 12
    }
    ListElement {
        name: "Paul"
        ip: "192.168.1.104"
        locked: false
        numUsers: 27
    }
    ListElement {
        name: "Steve"
        ip: "192.168.1.5"
        locked: false
        numUsers: 104
    }
    ListElement {
        name: "David"
        ip: "192.168.1.106"
        locked: true
        numUsers: 19
    }
    ListElement {
        name: "Richard"
        ip: "192.168.1.107"
        locked: true
        numUsers: 59
    }
    ListElement {
        name: "Patricia"
        ip: "192.168.1.108"
        locked: true
        numUsers: 0
    }
    ListElement {
        name: "Suzan"
        ip: "192.168.1.109"
        locked: false
        numUsers: 0
    }
}
