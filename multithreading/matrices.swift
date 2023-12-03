import Foundation

func multiplyMatrices(_ matrixA: [[Int]], _ matrixB: [[Int]]) -> [[Int]] {
    let numberOfRowsA = matrixA.count
    let numberOfColumnsA = matrixA[0].count
    let numberOfRowsB = matrixB.count
    let numberOfColumnsB = matrixB[0].count
    
    // Check if matrices can be multiplied
    assert(numberOfColumnsA == numberOfRowsB, "Invalid matrix dimensions for multiplication")

    // Result matrix
    var result = Array(repeating: Array(repeating: 0, count: numberOfColumnsB), count: numberOfRowsA)

    // Use DispatchQueue for multithreading
    let concurrentQueue = DispatchQueue(label: "matrixMultiplication", attributes: .concurrent)
    
    // Loop through each cell in the result matrix
    for i in 0..<numberOfRowsA {
        for j in 0..<numberOfColumnsB {
            concurrentQueue.async {
                // Calculate the value in the result matrix
                result[i][j] = (0..<numberOfColumnsA).reduce(0) { sum, k in
                    return sum + matrixA[i][k] * matrixB[k][j]
                }
            }
        }
    }

    // Wait for all tasks to complete
    concurrentQueue.sync(flags: .barrier) {}

    return result
}


// Example matrices
let matrixA = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

let matrixB = [
    [9, 8, 7],
    [6, 5, 4],
    [3, 2, 1]
]

// Multiply matrices
let resultMatrix = multiplyMatrices(matrixA, matrixB)

// Print the input
print("Input matrice A:")
for row in matrixA {
    print(row)
}

print("Input matrice B:")
for row in matrixB {
    print(row)
}

// Print the result
print("Result matrix:")
for row in resultMatrix {
    print(row)
}

