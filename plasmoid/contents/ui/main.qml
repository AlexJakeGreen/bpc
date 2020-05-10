/***************************************************************************
 *   Copyright (C) 2018 by Oleksandr Litvinov                              *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    property string message: ""
    property int power: 0

    function getPowerConsumption() {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "/sys/class/power_supply/BAT0/power_now");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var response = xhr.responseText;
                power = parseInt(response);
                message = (power / 1000000).toFixed(1) + "W";
            }
        }
        xhr.send();
    }

    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation


    Timer {
        id: readStarter
        interval: plasmoid.configuration.updateInterval
        running: true
        repeat: true
        onTriggered: getPowerConsumption()
    }
}
