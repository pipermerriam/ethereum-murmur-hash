//sol Murmur Hash
// @authors
// Piper Merriam <pipermerriam@gmail.com>
// A contract which computes a MurmurHash
contract MurmurHash {
        int32 c1 = 0xcc9e2d51;
        int32 c2 = 0x1b873593;
        int32 r1 = 15;
        int32 r2 = 13;
        int32 m = 5;
        int32 n = 0xe6546b64;

        int32 _hash;
        int32 numBits;

        function (bytes key, int32 len, int32 seed) {
                _hash = seed;

                numChunks = key.length / 4;

                // Check if this is an off-by-one error
                for (var i = 0; i < numChunks; i ++) {
                        // construct the 4-by
                        bytes4 fourByteChunk;

                        fourByteChunk[0] = key[(4 * i)];
                        fourByteChunk[1] = key[(4 * i) + 1];
                        fourByteChunk[2] = key[(4 * i) + 2];
                        fourByteChunk[3] = key[(4 * i) + 3];

                        k = fourByteChunk;
                        k *= c1;
                        k = k << r1;

                        _hash = hash ^ k;
                        _hash = hash << r2;
                        _hash = hash * m + n;
                }

                if ( key.length % 4 ) {
                        bytes remainingBytesInKey;
                        remainingBytes.length = key.length % 4;

                        for (var i = 0; i < remainingBytes.length; i++) {
                                // This explicitely swaps the order of the bytes (which
                                // should only be done on big-endian machines.
                                // TODO: is this big endian?
                                remainingBytes[i] = key[key.length - i];
                        }

                        remainingBytes = remainingBytes * c1;
                        remainingBytes = remainingBytes << r1;
                        remainingBytes = remainingBytes * c2;

                        _hash = _hash ^ remainingBytes;
                }

                _hash = _hash ^ len;
                _hash = _hash ^ (_hash >> 16);
                _hash = _hash * 0x85ebca6b;
                _hash = _hash ^ (_hash >> 13);
                _hash = _hash * 0xc2b2ae35;
                _hash = _hash ^ (_hash >> 16);

                return _hash;
        }
}
