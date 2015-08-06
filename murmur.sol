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

        function digest(bytes key, int seed) returns (bytes32 _hash) {
                //
                // Compute and return a Murmur3 Hash.
                // - https://en.wikipedia.org/wiki/MurmurHash
                //
                _hash = bytes32(seed);

                // Compute how many 4-byte chunks are in `key`
                uint numChunks = key.length / 4;

                // Iterate over 4-byte chunks of `key`
                for (var i = 0; i < numChunks; i ++) {
                        bytes32 k = 0;
                        bytes32 fourByteChunk = 0;

                        // construct the 4-byte chunk
                        fourByteChunk = fourByteChunk | key[(4 * i)];
                        fourByteChunk = fourByteChunk << 8;
                        fourByteChunk = fourByteChunk | key[(4 * i) + 1];
                        fourByteChunk = fourByteChunk << 8;
                        fourByteChunk = fourByteChunk | key[(4 * i) + 2];
                        fourByteChunk = fourByteChunk << 8;
                        fourByteChunk = fourByteChunk | key[(4 * i) + 3];
                        fourByteChunk = fourByteChunk << 8;

                        k = fourByteChunk;
                        k = bytes32(int(k) * c1);
                        k = k << r1;

                        _hash = _hash ^ k;
                        _hash = _hash << r2;
                        _hash = bytes32(int(_hash) * m + n);
                }

                // If there is a `tail` leftover that was not processed as a
                // 4-byte chunk, deal with it.
                if ( key.length % 4 > 0 ) {
                        bytes32 tail;

                        for (i = 0; i < key.length % 4; i++) {
                                // This explicitely swaps the order of the bytes (which
                                // should only be done on big-endian machines.
                                //
                                // TODO: is this big endian.  If not, then this
                                // needs to be switched to `key[numChunks * 4 +
                                // i]` to grab the bytes in the reverse order.
                                tail = tail | key[key.length - i];
                                tail = tail << 8;
                        }

                        tail = bytes32(int(tail) * c1);
                        tail = tail << r1;
                        tail = bytes32(int(tail) * c2);

                        _hash = _hash ^ tail;
                }

                _hash = _hash ^ bytes32(key.length);
                _hash = _hash ^ (_hash >> 16);
                _hash = bytes32(int(_hash) * 0x85ebca6b);
                _hash = _hash ^ (_hash >> 13);
                _hash = bytes32(int(_hash) * 0xc2b2ae35);
                _hash = _hash ^ (_hash >> 16);

                return _hash;
        }
}
