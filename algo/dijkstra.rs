use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};
use std::fs::File;
use std::io::{self, BufRead};

// Struct to represent a vertex and its neighbors
#[derive(Debug, PartialEq, Eq)]
struct Vertex {
    index: usize,
    neighbors: Vec<usize>,
}

impl Ord for Vertex {
    fn cmp(&self, other: &Self) -> Ordering {
        // Reverse ordering for min-heap
        other.index.cmp(&self.index)
    }
}

impl PartialOrd for Vertex {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

// Dijkstra's algorithm
fn dijkstra(graph: &Vec<Vertex>, start: usize, end: usize) -> Option<(usize, Vec<usize>)> {
    let mut distances: HashMap<usize, usize> = HashMap::new();
    let mut predecessors: HashMap<usize, usize> = HashMap::new();
    let mut visited: HashMap<usize, bool> = HashMap::new();

    let mut heap = BinaryHeap::new();

    // Initialize distances and heap
    for vertex in graph.iter() {
        distances.insert(vertex.index, usize::MAX);
        visited.insert(vertex.index, false);
        predecessors.insert(vertex.index, usize::MAX);
    }

    distances.insert(start, 0);

    heap.push(Vertex {
        index: start,
        neighbors: graph[start].neighbors.clone(),
    });

    while let Some(Vertex { index, neighbors }) = heap.pop() {
        if visited[&index] {
            continue;
        }

        visited.insert(index, true);

        for &neighbor in neighbors.iter() {
            let alt = distances[&index] + 1; // Assuming unweighted graph
            if alt < distances[&neighbor] {
                distances.insert(neighbor, alt);
                predecessors.insert(neighbor, index);
                heap.push(Vertex {
                    index: neighbor,
                    neighbors: graph[neighbor].neighbors.clone(),
                });
            }
        }
    }

    let mut path = Vec::new();
    let mut current = end;
    while current != usize::MAX {
        path.push(current);
        current = predecessors[&current];
    }

    path.reverse();

    // Return the shortest distance to the end vertex
    match distances.get(&end) {
        Some(&distance) => {
            if distance != usize::MAX {
                Some((distance, path))
            } else {
                None
            }
        }
        None => None,
    }
}

// Function to read graph from file
fn read_graph_from_file(filename: &str) -> Vec<Vertex> {
    let mut graph = Vec::new();

    if let Ok(file) = File::open(filename) {
        let reader = io::BufReader::new(file);

        for (i, line) in reader.lines().enumerate() {
            let line = line.unwrap();

            let neighbors: Vec<usize> = line
                .split(',')
                .filter_map(|s| s.trim().parse().ok())
                .collect();

            graph.push(Vertex {
                index: i,
                neighbors,
            });
        }
    } else {
        panic!("Error reading the file.");
    }

    graph
}

// Function to read user input
fn read_input(prompt: &str) -> usize {
    loop {
        println!("{}", prompt);

        let mut input = String::new();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");

        match input.trim().parse() {
            Ok(value) => return value,
            Err(_) => println!("Invalid input. Please enter a valid number."),
        }
    }
}

fn main() {
    // File path
    let filename = "../shared/graph_input.txt";

    let graph = read_graph_from_file(filename);

    let start: usize = read_input("Enter the start vertex: ");
    let end: usize = read_input("Enter the start vertex: ");

    match dijkstra(&graph, start, end) {
        Some((distance, path)) => {
            println!("Shortest path distance: {}", distance);
            for (i, v) in path.iter().enumerate() {
                if i == 0 {
                    print!("{}", v);
                } else {
                    print!(" -> {}", v)
                }
            }
        }
        None => println!("No path found."),
    }
}
