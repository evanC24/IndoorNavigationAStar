//
//  PriorityQueue.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//

import Foundation

struct PriorityQueue<T> {
    private var heap = [(Float, T)]()  // Store tuples of (priority, element)
    
    var isEmpty: Bool {
        return heap.isEmpty
    }
    
    mutating func put(_ element: T, priority: Float) {
        heap.append((priority, element))
        heapifyUp(from: heap.count - 1)
    }
    
    mutating func get() -> T? {
        guard !heap.isEmpty else { return nil }
        if heap.count == 1 {
            return heap.removeFirst().1
        } else {
            let first = heap.first?.1
            heap[0] = heap.removeLast()
            heapifyDown(from: 0)
            return first
        }
    }
    
    private mutating func heapifyUp(from index: Int) {
        var childIndex = index
        let child = heap[childIndex]
        var parentIndex = (childIndex - 1) / 2
        
        while childIndex > 0 && child.0 < heap[parentIndex].0 {
            heap[childIndex] = heap[parentIndex]
            childIndex = parentIndex
            parentIndex = (childIndex - 1) / 2
        }
        heap[childIndex] = child
    }
    
    private mutating func heapifyDown(from index: Int) {
        var parentIndex = index
        let count = heap.count
        let element = heap[parentIndex]
        
        while true {
            let leftChildIndex = 2 * parentIndex + 1
            let rightChildIndex = 2 * parentIndex + 2
            var swapIndex = parentIndex
            
            if leftChildIndex < count
                && heap[leftChildIndex].0 < heap[swapIndex].0
            {
                swapIndex = leftChildIndex
            }
            
            if rightChildIndex < count
                && heap[rightChildIndex].0 < heap[swapIndex].0
            {
                swapIndex = rightChildIndex
            }
            
            if swapIndex == parentIndex {
                break
            }
            
            heap[parentIndex] = heap[swapIndex]
            parentIndex = swapIndex
        }
        heap[parentIndex] = element
    }
}
