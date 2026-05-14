//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package inet.node.sdh.p2pNetworkExtended; 

import inet.node.sdh.SDHLTE;
import inet.node.sdh.PDHSource;
import inet.node.sdh.PDHSink;

network p2pNetworkExtended
{
    types:
        channel FiberLine extends ned.DatarateChannel {
            parameters:
                datarate = default(155.52Mbps); 
                delay = 2us;
                @display("m=arrow,ls=blue,2");
        }

    submodules:
        // 2 Fuentes y 2 Sumideros para el lado A
        sourceA[2]: PDHSource { @display("p=100,100,c,100"); }
        sinkA[2]: PDHSink { @display("p=100,300,c,100"); }
        
        lteA: SDHLTE {
            parameters:
                @display("p=300,200");
        }

        // 2 Fuentes y 2 Sumideros para el lado B
        sourceB[2]: PDHSource { @display("p=700,100,c,100"); }
        sinkB[2]: PDHSink { @display("p=700,300,c,100"); }

        lteB: SDHLTE {
            parameters:
                @display("p=500,200");
        }

    connections allowunconnected:            
        
        // --- CONEXIONES LADO A  ---
        // Conectar fuente 0 y sumidero 0
        sourceA[0].out --> lteA.pdhIn++;
        lteA.pdhOut++ --> sinkA[0].in;
        
        // Conectar fuente 1 y sumidero 1
        sourceA[1].out --> lteA.pdhIn++;
        lteA.pdhOut++ --> sinkA[1].in;

        // --- CONEXIONES LADO B  ---
        // Conectar fuente 0 y sumidero 0
        sourceB[0].out --> lteB.pdhIn++;
        lteB.pdhOut++ --> sinkB[0].in;
        
        
        sourceB[1].out --> lteB.pdhIn++;
        lteB.pdhOut++ --> sinkB[1].in;

        
        lteA.lineOut++ --> FiberLine --> lteB.lineIn++;  // Línea operativa A -> B
        lteA.lineOut++ --> FiberLine --> lteB.lineIn++;  // Línea protección A -> B
        
        lteB.lineOut++ --> FiberLine --> lteA.lineIn++;  // Línea operativa B -> A
        lteB.lineOut++ --> FiberLine --> lteA.lineIn++;  // Línea protección B -> A
}