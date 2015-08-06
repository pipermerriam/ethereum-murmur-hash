//sol Murmur Hash
// @authors
// Piper Merriam <pipermerriam@gmail.com>
// A contract which computes a MurmurHash
contract MurmurHash {
        int constant c1 = 0xcc9e2d51;
        int constant c2 = 0x1b873593;
        bytes32 constant r1 = 15;
        bytes32 constant r2 = 13;
        int constant m = 5;
        int constant n = 0xe6546b64;

        bytes32 _hash;
        int32 numBits;


        function digest(bytes key, int32 len, bytes32 seed) returns (bytes32 _hash) {
                // Temporary variables
                uint i;
                bytes32 k;
                bytes32 remainingBytes;

                _hash = seed;

                uint numChunks = key.length / 4;

                // Check if this is an off-by-one error
                for (i = 0; i < numChunks; i ++) {
                        // construct the 4-by
                        bytes4 b1 = key[(4 * i)] << 3 * 8;
                        bytes4 b2 = key[(4 * i) + 1] << 2 * 8;
                        bytes4 b3 = key[(4 * i) + 2] << 1 * 8;
                        bytes4 b4 = key[(4 * i) + 3];

                        bytes32 fourByteChunk = b1 | b2 | b3 | b4;

                        k = fourByteChunk;
                        k = bytes32(int(k) * c1);
                        k = k << r1;

                        _hash = _hash ^ k;
                        _hash = _hash << r2;
                        _hash = bytes32(int(_hash) * m + n);
                }

                if ( key.length % 4 > 0 ) {
                        uint tailLength = key.length % 4;

                        for (i = 0; i < tailLength; i++) {
                                // This explicitely swaps the order of the bytes (which
                                // should only be done on big-endian machines.
                                // TODO: is this big endian?
                                remainingBytes = remainingBytes | key[key.length - i];
                                remainingBytes = remainingBytes << 8;
                        }

                        remainingBytes = bytes32(int(remainingBytes) * c1);
                        remainingBytes = remainingBytes << r1;
                        remainingBytes = bytes32(int(remainingBytes) * c2);

                        _hash = _hash ^ remainingBytes;
                }

                _hash = _hash ^ bytes32(len);
                _hash = _hash ^ (_hash >> 16);
                _hash = bytes32(int(_hash) * 0x85ebca6b);
                _hash = _hash ^ (_hash >> 13);
                _hash = bytes32(int(_hash) * 0xc2b2ae35);
                _hash = _hash ^ (_hash >> 16);

                return _hash;
        }
}
