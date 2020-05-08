//
//  PlotGeometryCreator.swift
//  EquationRecognition
//
//  Created by artur_ios on 06.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//


import SceneKit
import Foundation


extension SCNVector3 {
    init(x: CGFloat, y: CGFloat) {
        self.init(x, y, 0)
    }
}


class PlotGeometryCreator {
    
    enum GrapghBuildingError: LocalizedError {
        case invalidPointType, invalidPointsCount, invalidPointsGrid
        
        var localizedDescription: String {
            switch self {
            case .invalidPointType:
                return "There are points of invalid type"
            case .invalidPointsCount:
                return "Count of points must be a square of a number"
            case .invalidPointsGrid:
                return "Points must make up a grid where the count of unique " +
                "x values and the count of unique z values must be equal to " +
                "square of points count"
                
                /*
                    Valid grid          Invalid grid
                           x                   x
                    |––––––>            |––––––>
                    | • • •             | ••• •
                    | • • •             |  • •
                    | • • •             | •  ••
                  z V                 z V   •
  
                 */
            }
        }
    }
    
    
    func build(_ points: [Point?]) throws -> SCNGeometry? {
        var geometry: SCNGeometry?
        switch points {
        case let points where points is [Vector2]:
            geometry = try build2DGeometry(points as! [Vector2])
        case let points where points is [Vector3?]:
            geometry = try build3DGeometry(points as! [Vector3?])
        default:
            return nil
        }
        return geometry
    }
    
    private func build2DGeometry(_ vectors: [Vector2]) throws -> SCNGeometry? {
        guard vectors.count > 0 else { return nil }
        
        let vectorAdapter = VectorAdapter()
        let points = vectors.map { vectorAdapter.convert($0) }
        let shiftedPoints = [CGPoint](points
            .map { CGPoint(x: $0.x, y: $0.y + 0.01) }
            .reversed())
        
        let artist = BezierArtist()
        let path = artist.merge(artist.bezierPath(points: points.appending(contentsOf: shiftedPoints)))
        
        let shape = SCNShape(path: path, extrusionDepth: 0.2)
        shape.chamferRadius = 0.1
        
        return shape
    }
    
    private func build3DGeometry(_ points: [Vector3?]) throws -> SCNGeometry? {
        guard sqrt(Double(points.count)).isInteger else {
            throw GrapghBuildingError.invalidPointsCount
        }
        
        let gridSideSize = Int(sqrt(Double(points.count)))
        
        // TODO: Add a validation that every point is in a grid


        var indices: [Int] = []

        let pointsCount = points.count

        for i in 0..<pointsCount {
            guard i + gridSideSize < pointsCount else { continue }
            if (i + 1) % gridSideSize != 0,
                let trianglePoints = trianglePoints(origin: i, gridSideSize: gridSideSize, direction: .down, points: points) {
                indices.append(contentsOf: trianglePoints)
            }
            if i % gridSideSize != 0,
                let trianglePoints = trianglePoints(origin: i, gridSideSize: gridSideSize, direction: .up, points: points) {
                indices.append(contentsOf: trianglePoints)
            }
        }

        let source = SCNGeometrySource(vertices: points.map {
            $0 ?? SCNVector3(1, 1, 1)
        })
        let element = SCNGeometryElement(indices: indices.map { UInt16($0) },
                                         primitiveType: .triangles)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    
    /*
     
             down triangles
     
          0•–––•1      0•–––•1
           |  /          \  |
           | /            \ |
           |/              \|
          2•                •2
     
              up triangles
        
               •1       0•
              /|         |\
             / |         | \
            /  |         |  \
          0•–––•2       1•–––•2
     
     */
    
    private enum TriangleDirection { case down, up }
    private func trianglePoints(origin: Int, gridSideSize: Int, direction: TriangleDirection, points: [Vector3?]) -> [Int]? {
        let indexesGroups: [[Int]]
        switch direction {
        case .down:
            indexesGroups = [
                [origin, origin + gridSideSize, origin + 1],
                [origin, origin + gridSideSize, origin + gridSideSize + 1]
            ]
        case .up:
            indexesGroups = [
                [origin, origin + gridSideSize - 1, origin + gridSideSize],
                [origin, origin - 1, origin + gridSideSize]
            ]
        }
        
        for indexesGroup in indexesGroups {
            var isGroupAppropriate = false
            
            inner:
            for pointIndex in indexesGroup {
                if points.hasIndex(pointIndex), let _ = points[pointIndex] {
                    isGroupAppropriate = true
                } else {
                    isGroupAppropriate = false
                    break inner
                }
            }
            if isGroupAppropriate {
                return indexesGroup
            }
        }

        return nil
    }
    
}
