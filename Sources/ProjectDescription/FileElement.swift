import Foundation

/// File element
///
/// - glob: a glob pattern for files to include
/// - folderReference: a single path to a directory
///
/// Note: For convenience, an element can be represented as a string literal
///       `"some/pattern/**"` is the equivalent of `FileElement.glob(pattern: "some/pattern/**")`
public enum FileElement: Codable, Equatable {
    /// A glob pattern of files to include
    case glob(pattern: Path, tags: [String] = [])

    /// Relative path to a directory to include
    /// as a folder reference
    case folderReference(path: Path, tags: [String] = [])

    private enum TypeName: String, Codable {
        case glob
        case folderReference
    }

    private var typeName: TypeName {
        switch self {
        case .glob:
            return .glob
        case .folderReference:
            return .folderReference
        }
    }

    public enum CodingKeys: String, CodingKey {
        case type
        case pattern
        case path
        case tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(TypeName.self, forKey: .type)
        let tags = try? container.decode([String].self, forKey: .tags)
        switch type {
        case .glob:
            let pattern = try container.decode(Path.self, forKey: .pattern)
            self = .glob(pattern: pattern, tags: tags ?? [])
        case .folderReference:
            let path = try container.decode(Path.self, forKey: .path)
            self = .folderReference(path: path, tags: tags ?? [])
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(typeName, forKey: .type)
        switch self {
        case let .glob(pattern: pattern, tags: tags):
            try container.encode(pattern, forKey: .pattern)
            try container.encode(tags, forKey: .tags)
        case let .folderReference(path: path, tags: tags):
            try container.encode(path, forKey: .path)
            try container.encode(tags, forKey: .tags)
        }
    }
}

extension FileElement: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .glob(pattern: Path(value))
    }
}

extension FileElement: ExpressibleByStringInterpolation {}

extension Array: ExpressibleByUnicodeScalarLiteral where Element == FileElement {
    public typealias UnicodeScalarLiteralType = String
}

extension Array: ExpressibleByExtendedGraphemeClusterLiteral where Element == FileElement {
    public typealias ExtendedGraphemeClusterLiteralType = String
}

extension Array: ExpressibleByStringLiteral where Element == FileElement {
    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self = [.glob(pattern: Path(value))]
    }
}
