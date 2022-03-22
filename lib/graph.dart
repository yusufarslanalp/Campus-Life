// @dart=2.9

//import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';

/*double d2r = ( math.pi / 180.0);
//calculate haversine distance for linear distance
double haversine_km(double lat1, double long1, double lat2, double long2)
{
  double dlong = (long2 - long1) * d2r;
  double dlat = (lat2 - lat1) * d2r;
  double a = math.pow(  math.sin(dlat/2.0), 2) + math.cos(lat1*d2r) * math.cos(lat2*d2r) * math.pow( math.sin(dlong/2.0), 2);
  double c = 2 * math.atan2( math.sqrt(a), math.sqrt(1-a));
  double d = 6367 * c;

  return d;
}*/


class Node {
  int node_num;
  List<double> cordinate;
  List<Adjacent> adjacents = [];

  Node(this.node_num, this.cordinate, List<int> adj_nums) {
    adjacents = [];
    for (int i = 0; i < adj_nums.length; i++) {
      adjacents.add(Adjacent(adj_nums[i]));
    }
  }

  int
  get_adj( int index )
  {
    return adjacents[index].node_num;
  }

  void
  set_drivable( int node_num, bool value )
  {
    for( int i = 0; i < adjacents.length; i++ )
    {
      if( adjacents[i].node_num == node_num )
      {
        adjacents[i].drivable = value;
      }
    }
  }


  void
  set_confortable( int node_num, bool value )
  {
    for( int i = 0; i < adjacents.length; i++ )
    {
      if( adjacents[i].node_num == node_num )
      {
        adjacents[i].comfortable = value;
      }
    }
  }

  bool
  is_confortable( node_num )
  {
    for( int i = 0; i < adjacents.length; i++ )
    {
      if( adjacents[i].node_num == node_num )
      {
        if( adjacents[i].comfortable == true )
        {
          return true;
        }
        else { return false; }
      }
    }
    return false;
  }

  bool has_adj( adj_num )
  {
    for( int i = 0; i < adjacents.length; i++ )
    {
      if( adjacents[i].node_num == adj_num )
      {
        return true;
      }
    }
    return false;
  }
}

class Adjacent {
  int node_num;
  bool walkable;
  bool drivable;
  bool comfortable;

  Adjacent( this.node_num );

  //int node_num;
  //int distance;


  @override
  String toString() {
    // TODO: implement toString
    return  node_num.toString();
  }
}

class Graph {
  int size;
  List<Node> graph;

  //int size;
  //List<List<Adjacent>> graph;

  List<int> distance = [];
  List<int> prew = [];

  Graph( this.size )
  {
    print( size );
    graph = new List<Node>( size );
    create_nodes();
  }

  void
  set_node( Node node )
  {
    graph[node.node_num] = node;
  }

  //ls[i][0]: from node
  //ls[i][1]: to node
  void
  set_drivables( List<List<int>> ls, bool value )
  {
    for( int i = 0; i < ls.length; i++ )
    {
      graph[ ls[i][0] ].set_drivable(  ls[i][1], value);
    }
  }

  //ls[i][0]: node1
  //ls[i][1]: node1 //bidirectional
  void
  set_confortable( List<List<int>> ls, bool value )
  {
    for( int i = 0; i < ls.length; i++ )
    {
      graph[ ls[i][0] ].set_confortable(  ls[i][1], value);
      graph[ ls[i][1] ].set_confortable(  ls[i][0], value);
    }
  }

  int
  closest_node( List<double> current_cordinate )
  {
    List<int> distances = [];
    int distance;
    for( int i = 0; i < graph.length; i++ )
    {
      distance = haversine(  current_cordinate[0], current_cordinate[1],
              graph[i].cordinate[0], graph[i].cordinate[1]);
      distances.add(distance);
      
    }
    int min_distance = distances.reduce( min );
    int min_index = distances.indexOf( min_distance );
    return min_index;
    
  }


  static int
  get_distance( Node n1, Node n2, String road_choice )
  {
    //print( "get distance -------------------------------------------------------------------------------------------------------------------" );

    int distance;
    if( n1.has_adj( n2.node_num ) | n2.has_adj( n1.node_num ) )
    {
      distance = haversine( n1.cordinate[0], n1.cordinate[1], n2.cordinate[0], n2.cordinate[1] );
      if( road_choice == "Yürüyerek - Gölgelik yol" )
      {
        //print( "get distance2222222 -------------------------------------------------------------------------------------------------------------------" );

        if( n1.is_confortable( n2.node_num ) )
        {
          print( "get distance3333333333 -------------------------------------------------------------------------------------------------------------------" );

          distance = (distance * 0.6).toInt();
        }
      }
      return distance;
    }
    else return -1;
  }

  static int haversine(double lat1, double long1, double lat2, double long2)
  {
    double d2r = ( math.pi / 180.0);

    double dlong = (long2 - long1) * d2r;
    double dlat = (lat2 - lat1) * d2r;
    double a = math.pow(  math.sin(dlat/2.0), 2) + math.cos(lat1*d2r) * math.cos(lat2*d2r) * math.pow( math.sin(dlong/2.0), 2);
    double c = 2 * math.atan2( math.sqrt(a), math.sqrt(1-a));
    double d = 6367 * c;
    d = d * 1000; //km to m

    //print( "DISTANCE:::::::" + d.toString() );

    return d.toInt();
  }

  @override
  String toString() {
    // TODO: implement toString
    String result = "";

    for( int i = 0; i < size; i++ )
    {
      result += i.toString();
      result += " -> ";
      result += graph[i].toString();
      result += "\n";
    }

    return result;
  }

  int
  find_min_index( List<int> ls, List<int> unvisited )
  {
    int min_index = unvisited[0];
    for( int i = 1; i < unvisited.length; i++ )
    {
      if( ls[ unvisited[i] ] < ls[min_index]  )
      {
        min_index = unvisited[i];
      }
    }
    return min_index;
  }

  List<List<double>>
  get_cordinates( List<int> nodes )
  {
    List<List<double>> cordinates = [];
    for( int i = 0; i < nodes.length; i++ )
    {
      cordinates.add( graph[nodes[i]].cordinate );
    }
    return cordinates;
  }

  List<int>
  shortest_path( int start, int end, String road_choice )
  {
    //print( "Drivable 27 to 26: " + graph[27].adjacents[1].drivable.toString() );
    List<int> path = [];

    dijkstra(start, road_choice);
    for( int i = 0; i < size; i++ )
    {
      //print( start.toString() + " to " + i.toString() + ", cost: " + distance[i].toString() + " prew: " + prew[i].toString() );
      print( i.toString() + ": " + prew[i].toString() );
    }

    int current_node = end;

    path.insert(0, end);

    print( "HEREEEEEEEEEee***********************************************************************************************************" );

    while( current_node != start )
    {
      current_node = prew[current_node];
      print( "Current Node: " + current_node.toString() );
      path.insert(0, current_node);
    }

    print( path );
    return path;

  }
  void
  dijkstra( int start, String road_choice )
  {
    List<int> visited = [];
    List<int> unvisited = [];
    bool current_adj_drivable;

    for( int i = 0; i < size; i++ )
    {
      unvisited.add( i );
      distance.add( 10000000 ); //set all distances to inf (10 000m)
      prew.add( -1 );
    }

    distance[start] = 0;

    int current_node;
    int new_distance;
    int current_adj;
    int count = 0;
    while( unvisited.length > 0 )
    {
      //print( "while_in" );
      current_node = find_min_index( distance, unvisited );
      //print( "current_node: " + current_node.toString() );
      for( int i = 0; i < graph[current_node].adjacents.length; i++ )
      {
        current_adj_drivable =  graph[current_node].adjacents[i].drivable;
        //if by_what==car and road is not drivable don't go that way
        if( (road_choice != "Arabayla" ) | ( current_adj_drivable != false ) )
        {
          //count += 1;
          //if ( count == 1000 ) return;

          ////new_distance = distance[current_node] + graph[current_node][i].distance;
          current_adj = graph[current_node].get_adj( i );
          //print( "current_adj: " + current_adj.toString() );

          print( "*************************************************************************************************************************************" );


          new_distance =  distance[current_node] +
              get_distance( graph[current_node] , graph[current_adj], road_choice );

          if( new_distance < distance[current_adj] )
          {
            prew[ current_adj ] = current_node;
            distance[ current_adj ] = new_distance;
          }
        }

      }
      unvisited.remove( current_node );
      //print( "while_out: " + unvisited.length.toString() );
    }

  }


  void
  create_nodes(  )
  {
    //          node_num   cordinate              ajjacents
    set_node( Node( 0 , [ 40.809090, 29.364858 ], [1, 143, 123, 139 ]) );
    set_node( Node( 1 , [ 40.809009, 29.364718 ], [ 2, 143, 0, 22 ]) );
    set_node( Node( 2 , [ 40.809012, 29.364137 ], [ 15, 1 ]) );
    set_node( Node( 3 , [ 40.809246, 29.364073 ], [ 4, 143 ]) );
    set_node( Node( 4 , [ 40.809554, 29.363955 ], [ 5, 88, 3 ]) );
    set_node( Node( 5 , [ 40.809586, 29.363293 ], [ 83, 4 ]) );
    set_node( Node( 6 , [ 40.811204, 29.362071 ], [ 92, 97, 7, 91, 8 ]) );
    set_node( Node( 7 , [ 40.811473, 29.362197 ], [ 6 ]) );
    set_node( Node( 8 , [ 40.810872, 29.361851 ], [ 6, 9 ]) );
    set_node( Node( 9 , [ 40.810559, 29.361629 ], [ 8, 105, 87 ]) );
    set_node( Node( 10 , [ 40.810231, 29.361465 ], [ 87, 85 ]) );
    set_node( Node( 11, [ 40.809884, 29.361276 ], [ 85, 12 ]) );
    set_node( Node( 12 , [ 40.809596, 29.361058 ], [ 11, 13 ]) );
    set_node( Node( 13 , [ 40.809279, 29.360865 ], [ 16, 12, 14 ]) );
    set_node( Node( 14 , [ 40.808953, 29.362056 ], [ 13, 21 ]) );
    set_node( Node( 15, [ 40.808809, 29.363939 ], [ 21, 2 ]) );
    set_node( Node( 16 , [ 40.809382, 29.360277 ], [ 13, 17 ]) );
    set_node( Node( 17, [ 40.809092, 29.360159 ], [ 16, 18 ]) );
    set_node( Node( 18 , [ 40.808801, 29.360248 ], [ 17, 19 ]) );
    set_node( Node( 19 , [ 40.808499, 29.360757 ], [ 18, 20 ]) );
    set_node( Node( 20 , [ 40.808120, 29.362621 ], [ 19, 21, 22 ]) );
    set_node( Node( 21 , [ 40.808862, 29.362827 ], [ 14, 15, 20 ]) );
    set_node( Node( 22 , [ 40.807841, 29.364378 ], [ 20, 1, 23 ]) );
    set_node( Node( 23 , [ 40.807686, 29.364330 ], [ 24, 22, 142 ]) );
    set_node( Node( 24 , [ 40.807752, 29.364061 ], [ 23, 25 ]) );
    set_node( Node( 25 , [ 40.807470, 29.363989 ], [ 24, 26 ]) );
    set_node( Node( 26 , [ 40.807381, 29.364260 ], [ 25, 27 ]) );
    set_node( Node( 27 , [ 40.807023, 29.363492 ], [ 32, 26, 28 ]) );
    set_node( Node( 28 , [ 40.806138, 29.363330 ], [ 29, 27, 31 ]) );
    set_node( Node( 29 , [ 40.806342, 29.362179 ], [ 51, 28, 30 ]) );
    set_node( Node( 30 , [ 40.805896, 29.362043 ], [ 29, 46 ]) );
    set_node( Node( 31 , [ 40.805666, 29.363178 ], [ 28, 47 ]) );
    set_node( Node( 32 , [ 40.807447, 29.361402 ], [ 145, 27, 51, 33 ]) );
    set_node( Node( 33 , [ 40.806824, 29.359508 ], [ 56, 145, 32, 51, 35, 34 ]) );
    set_node( Node( 34 , [ 40.806677, 29.359159 ], [ 33 ]) );
    set_node( Node( 35 , [ 40.805937, 29.359215 ], [ 52, 33, 49, 36 ]) );
    set_node( Node( 36 , [ 40.805604, 29.359108 ], [ 37, 38, 35 ]) );
    set_node( Node( 37 , [ 40.805563, 29.359365 ], [ 36 ]) );
    set_node( Node( 38 , [ 40.805441, 29.359065 ], [ 39, 36, 40 ]) );
    set_node( Node( 39 , [ 40.805498, 29.358791 ], [ 38 ]) );
    set_node( Node( 40 , [ 40.805213, 29.358979 ], [ 36, 41, 42 ]) );
    set_node( Node( 41 , [ 40.805140, 29.359532 ], [ 40 ]) );
    set_node( Node( 42 , [ 40.804398, 29.358729 ], [ 77, 40, 43, 79 ]) );
    set_node( Node( 43 , [ 40.804072, 29.360559 ], [ 42, 44 ]) );
    set_node( Node( 44 , [ 40.804373, 29.361556 ], [ 45, 43, 48 ]) );
    set_node( Node( 45 , [ 40.804891, 29.361707 ], [ 46, 44 ]) );
    set_node( Node( 46 , [ 40.805457, 29.361873 ], [ 49, 30, 47, 45 ]) );
    set_node( Node( 47 , [ 40.805278, 29.363058 ], [ 46, 31, 48 ]) );
    set_node( Node( 48 , [ 40.804866, 29.362897 ], [ 47, 44 ]) );
    set_node( Node( 49 , [ 40.805687, 29.360525 ], [ 35, 50, 46 ]) );
    set_node( Node( 50 , [ 40.806246, 29.360729 ], [ 51, 49 ]) );
    set_node( Node( 51 , [ 40.806580, 29.360818 ], [ 33, 29, 50 ]) );
    set_node( Node( 52 , [ 40.806171, 29.357841 ], [ 53, 35, 74 ]) );
    set_node( Node( 53 , [ 40.806218, 29.357595 ], [ 70, 54, 52, 146 ]) );
    set_node( Node( 54 , [ 40.806693, 29.357809 ], [ 55, 56, 53 ]) );
    set_node( Node( 55 , [ 40.807112, 29.357854 ], [ 57, 56, 54 ]) );
    set_node( Node( 56 , [ 40.806981, 29.358599 ], [ 55, 33, 54 ]) );
    set_node( Node( 57 , [ 40.807165, 29.357610 ], [ 59, 58, 55 ]) );
    set_node( Node( 58 , [ 40.808140, 29.357689 ], [ 60, 101, 145, 57, 59 ]) );
    set_node( Node( 59 , [ 40.807321, 29.356761 ], [ 147, 58, 57, 68 ]) );
    set_node( Node( 60 , [ 40.808263, 29.357012 ], [ 62, 58, 61 ]) );
    set_node( Node( 61 , [ 40.807998, 29.356497 ], [ 62, 60, 125 ]) );
    set_node( Node( 62 , [ 40.808351, 29.356607 ], [ 63, 60 ]) );
    set_node( Node( 63 , [ 40.808487, 29.355774 ], [ 64, 62 ]) );
    set_node( Node( 64 , [ 40.808127, 29.355626 ], [ 65, 63 ]) );
    set_node( Node( 65 , [ 40.807835, 29.355535 ], [ 67, 64, 66 ]) );
    set_node( Node( 66 , [ 40.807729, 29.356019 ], [ 65, 125 ]) );
    set_node( Node( 67 , [ 40.807198, 29.355327 ], [ 65, 68, 71 ]) );
    set_node( Node( 68 , [ 40.807041, 29.356177 ], [ 67, 147, 59, 70 ]) );
    set_node( Node( 69 , [ 40.806459, 29.355963 ], [ 70 ]) );
    set_node( Node( 70 , [ 40.806537, 29.355986 ], [ 68, 53, 69 ]) );
    set_node( Node( 71 , [ 40.806058, 29.354877 ], [ 67, 146 ]) );
    set_node( Node( 72 , [ 40.805544, 29.353455 ], [ 146 ]) );
    set_node( Node( 73 , [ 40.805051, 29.355295 ], [ 146, 74 ]) );
    set_node( Node( 74 , [ 40.804639, 29.357366 ], [ 73, 52, 77, 75 ]) );
    set_node( Node( 75 , [ 40.803995, 29.357173 ], [ 74, 76, 81 ]) );
    set_node( Node( 76 , [ 40.803946, 29.357441 ], [ 75, 77, 78 ]) );
    set_node( Node( 77 , [ 40.804578, 29.357677 ], [ 74, 42 ]) );
    set_node( Node( 78 , [ 40.803845, 29.357897 ], [ 76, 79 ]) );
    set_node( Node( 79 , [ 40.803730, 29.358520 ], [ 78, 42, 80, 82 ]) );
    set_node( Node( 80 , [ 40.803616, 29.359067 ], [ 79 ]) );
    set_node( Node( 81 , [ 40.803376, 29.356964 ], [ 75, 82 ]) );
    set_node( Node( 82 , [ 40.803139, 29.358267 ], [ 81, 79 ]) );
    set_node( Node( 83 , [ 40.810004, 29.361976 ], [ 86, 5, 84 ]) );
    set_node( Node( 84 , [ 40.809902, 29.361761 ], [ 85, 83 ]) );
    set_node( Node( 85 , [ 40.810029, 29.361364 ], [ 10, 84, 11 ]) );
    set_node( Node( 86 , [ 40.810226, 29.361968 ], [ 87, 83 ]) );
    set_node( Node( 87 , [ 40.810383, 29.361576 ], [ 9, 86, 10 ]) );
    set_node( Node( 88 , [ 40.809947, 29.363306 ], [ 105, 4 ]) );
    set_node( Node( 89 , [ 40.810711, 29.362711 ], [ 90, 105 ]) );
    set_node( Node( 90 , [ 40.811019, 29.362561 ], [ 91, 89 ]) );
    set_node( Node( 91 , [ 40.811208, 29.362633 ], [ 6, 144, 90 ]) );
    set_node( Node( 92 , [ 40.811216, 29.361296 ], [ 100, 93, 6, 8 ]) );
    set_node( Node( 93 , [ 40.811373, 29.361377 ], [ 94, 92 ]) );
    set_node( Node( 94 , [ 40.811595, 29.361457 ], [ 95, 97, 93 ]) );
    set_node( Node( 95 , [ 40.812170, 29.361809 ], [ 99, 144, 96, 94 ]) );
    set_node( Node( 96 , [ 40.811851, 29.361966 ], [ 95, 97 ]) );
    set_node( Node( 97 , [ 40.811509, 29.361859 ], [ 94, 96, 6 ]) );
    set_node( Node( 98 , [ 40.812200, 29.361784 ], [ 121 ]) );
    set_node( Node( 99 , [ 40.812394, 29.361231 ], [ 131, 100 ]) );
    set_node( Node( 100 , [ 40.811195, 29.360791 ], [ 102, 99, 92, 106 ]) );
    set_node( Node( 101 , [ 40.809395, 29.358017 ], [ 103, 106, 58 ]) );
    set_node( Node( 102 , [ 40.811217, 29.358650 ], [ 117, 133, 100, 103 ]) );
    set_node( Node( 103 , [ 40.810003, 29.358233 ], [ 104, 102, 106, 101 ]) );
    set_node( Node( 104 , [ 40.810072, 29.357388 ], [ 110, 108, 103, 107 ]) );
    set_node( Node( 105 , [ 40.810235, 29.363083 ], [ 9, 89, 88 ]) );
    set_node( Node( 106,  [ 40.809893, 29.358820 ], [ 103, 100, 101 ]) );
    set_node( Node( 107 , [ 40.809873, 29.357149 ], [ 110, 104 ]) );
    set_node( Node( 108 , [ 40.810779, 29.357633 ], [ 106, 117, 104, 109 ]) );
    set_node( Node( 109 , [ 40.810789, 29.357328 ], [ 108 ]) );
    set_node( Node( 110 , [ 40.810032, 29.357047 ], [ 111, 104, 107 ]) );
    set_node( Node( 111 , [ 40.809985, 29.356500 ], [ 110, 112 ]) );
    set_node( Node( 112 , [ 40.809968, 29.355256 ], [ 116, 11, 113 ]) );
    set_node( Node( 113 , [ 40.809870, 29.354859 ], [ 112 ]) );
    set_node( Node( 114 , [ 40.810975, 29.354957 ], [ 122, 115 ]) );
    set_node( Node( 115 , [ 40.810949, 29.355442 ], [ 114, 120, 116 ]) );
    set_node( Node( 116 , [ 40.810450, 29.355405 ], [ 115, 112 ]) );
    set_node( Node( 117 , [ 40.811187, 29.357731 ], [ 119, 118, 102, 108 ]) );
    set_node( Node( 118 , [ 40.811684, 29.357489 ], [ 117 ]) );
    set_node( Node( 119 , [ 40.811264, 29.356696 ], [ 120, 117 ]) );
    set_node( Node( 120 , [ 40.811383, 29.355526 ], [ 121, 119, 115 ]) );
    set_node( Node( 121 , [ 40.811448, 29.354780 ], [ 98, 120, 122 ]) );
    set_node( Node( 122 , [ 40.811027, 29.354651 ], [ 121, 114 ]) );
    set_node( Node( 123 , [ 40.810877, 29.365178 ], [ 124, 143 ]) );
    set_node( Node( 124 , [ 40.811280, 29.365221 ], [ 126, 127, 123 ]) );
    set_node( Node( 125 , [ 40.807696, 29.356413 ], [ 66, 61, 147 ]) );
    set_node( Node( 126 , [ 40.811364, 29.364531 ], [ 144, 124 ]) );
    set_node( Node( 127 , [ 40.811753, 29.364545 ], [ 128, 124 ]) );
    set_node( Node( 128 , [ 40.812191, 29.364444 ], [ 129, 127 ]) );
    set_node( Node( 129 , [ 40.813681, 29.362772 ], [ 130, 128 ]) );
    set_node( Node( 130 , [ 40.813714, 29.361576 ], [ 129, 131, 132 ]) );
    set_node( Node( 131 , [ 40.813019, 29.361350 ], [ 132, 130, 99 ]) );
    set_node( Node( 132 , [ 40.813241, 29.360513 ], [ 130, 131, 135, 134 ]) );
    set_node( Node( 133 , [ 40.812686, 29.359134 ], [ 136, 134, 102, 118 ]) );
    set_node( Node( 134 , [ 40.812918, 29.359740 ], [ 132, 135, 133 ]) );
    set_node( Node( 135 , [ 40.812791, 29.360271 ], [ 134, 132 ]) );
    set_node( Node( 136 , [ 40.816395, 29.360493 ], [ 137, 133 ]) );
    set_node( Node( 137 , [ 40.816799, 29.361014 ], [ 138, 136 ]) );
    set_node( Node( 138 , [ 40.816627, 29.361566 ], [ 137 ]) );
    set_node( Node( 139 , [ 40.809074, 29.365239 ], [ 0, 140, 141 ]) );
    set_node( Node( 140 , [ 40.809229, 29.365756 ], [ 141, 139 ]) );
    set_node( Node( 141 , [ 40.808825, 29.365649 ], [ 139, 140, 142 ]) );
    set_node( Node( 142 , [ 40.807567, 29.365057 ], [ 23, 141 ]) );
    set_node( Node( 143 , [ 40.809228, 29.364722 ], [ 3, 123, 0, 1 ]) );
    set_node( Node( 144 , [ 40.811832, 29.362788 ], [ 95, 126, 91 ]) );
    set_node( Node( 145 , [ 40.807727, 29.359795 ], [ 58, 32, 33 ]) );
    set_node( Node( 146 , [ 40.805597, 29.354984 ], [ 72, 71, 53, 73 ]) );
    set_node( Node( 147 , [ 40.807410, 29.356303 ], [ 125, 59, 68 ]) );

    List<List<int>> non_drivable_ls =  [
                            [123, 143], [144, 91], [91, 144], [95, 99], [99, 95],
                            [95, 96], [96, 95], [94, 97], [97, 94], [92, 6], [6, 92],
                            [92, 93], [20, 19], [1, 22], [21, 14], [13, 14], [13, 12],
                            [22, 23], [27, 26], [5, 83], [88, 105], [100, 106], [101, 106],
                            [101, 104], [103, 104]
                          ];
    set_drivables(  non_drivable_ls, false );

    List<List<int>> confortable_ls = [ [100, 106], [106, 101] ];

    set_confortable( confortable_ls , true );

    print( "CONFORTABLE:::::::::::::::::::::::::::" + graph[100].adjacents[3].comfortable.toString() );

  }
}




/*
void main() {
  Graph g = new Graph( 7 );
  g.add_adj(0, 1, 3);
  g.add_adj(0, 2, 6);
  g.add_adj(1, 0, 3);
  g.add_adj(1, 2, 2);
  g.add_adj(1, 3, 1);
  g.add_adj(2, 1, 6);
  g.add_adj(2, 1, 2);
  g.add_adj(2, 3, 1);
  g.add_adj(2, 4, 4);
  g.add_adj(2, 5, 2);
  g.add_adj(3, 1, 1);
  g.add_adj(3, 2, 1);
  g.add_adj(3, 4, 2);
  g.add_adj(3, 6, 4);
  g.add_adj(4, 2, 4);
  g.add_adj(4, 3, 2);
  g.add_adj(4, 5, 2);
  g.add_adj(4, 6, 1);
  g.add_adj(5, 2, 2);
  g.add_adj(5, 4, 2);
  g.add_adj(5, 6, 1);
  g.add_adj(6, 3, 4);
  g.add_adj(6, 4, 1);
  g.add_adj(6, 5, 1);
  //g.foo();
  g.dijkstra(0);
  //print( g );

  print( haversine_km( 40.809090, 29.364858, 40.810877, 29.365178 ) );

  runApp(const MyApp());
}
*/