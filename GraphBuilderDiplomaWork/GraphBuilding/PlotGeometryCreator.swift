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
    
    
    func build(_ points: [Point]) throws -> SCNGeometry? {
        var geometry: SCNGeometry?
        switch points {
        case let points where points is [Vector2]:
            geometry = try build2DGeometry(points as! [Vector2])
        case let points where points is [Vector3]:
            geometry = try build3DGeometry(points as! [Vector3])
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
    
    private func build3DGeometry(_ points: [Vector3]) throws -> SCNGeometry? {
        guard sqrt(Double(points.count)).isInteger else {
            throw GrapghBuildingError.invalidPointsCount
        }
        
        let gridSideSize = Int(sqrt(Double(points.count)))
        
        let uniqueX = Set(points.map { $0.x })
        let uniqueZ = Set(points.map { $0.z })
        
        guard gridSideSize == uniqueX.count,
            gridSideSize == uniqueZ.count else {
                throw GrapghBuildingError.invalidPointsGrid
        }


        var indices: [Int] = []

        let pointsCount = points.count

        for i in 0..<pointsCount {
            guard i + gridSideSize < pointsCount else { continue }
            if (i + 1) % gridSideSize != 0 {
                indices.append(contentsOf:
                    downTrianglePoints(origin: i, gridSideSize: gridSideSize))
            }
            if i % gridSideSize != 0 {
                indices.append(contentsOf:
                    upTrianglePoints(origin: i, gridSideSize: gridSideSize))
            }
        }

        let source = SCNGeometrySource(vertices: points)
        let element = SCNGeometryElement(indices: indices.map { UInt16($0) },
                                         primitiveType: .triangles)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    
    /*
     
       0•–––•2
        |  /
        | /
        |/
       1•
     
     */
    private func downTrianglePoints(origin: Int, gridSideSize: Int) -> [Int] {
        [origin, origin + gridSideSize, origin + 1]
    }
    
    
    /*
    
           •0
          /|
         / |
        /  |
      1•–––•2
    
    */
    private func upTrianglePoints(origin: Int, gridSideSize: Int) -> [Int] {
        [origin, origin + gridSideSize - 1, origin + gridSideSize]
    }
    
}
