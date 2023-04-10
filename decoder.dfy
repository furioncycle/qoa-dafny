module {:options "-functionSyntax:4"} Qoa {
    
    datatype Result<T> = Failure(error: string) | Success(value: T)

    class FileHeader {
        const Magic: string 
        const Samples: int

        constructor (m: string, s: int)
            requires m == "qoaf"
            ensures Magic == "qoaf"
        { 
            Magic, Samples := m, s;
        }
    } 

    class FrameHeader {
        const NumChannels: int
        const SampleRate: int
        const FSamples: int
        const FSize: int

        constructor (n: int , s: int, fs: int, fsize: int) {
            NumChannels, SampleRate, FSamples, FSize := n, s, fs, fsize;
        }
    }

    class Lms_State {
        var History: array?<int>
        var Weights: array?<int>

        constructor()
            ensures fresh(Weights)
            ensures fresh(History)
        {
            History, Weights := new int[4], new int[4];
        }

    } 
    
    class Qoa_Slices {
        var  Sf_Quant : bv4
        var Qr: array<bv3> 

        constructor() {
            Qr := new bv3[17];
        }
    }

    class Frame {
        const header: FrameHeader
        const Lms_States: array<Lms_State?>
        const Slices: array2<Qoa_Slices?>
        
        constructor(h: FrameHeader)
            requires h.NumChannels > 0
        {
            header, Lms_States, Slices := h, new Lms_State?[h.NumChannels], new Qoa_Slices?[256, h.NumChannels];
        }
    }

    class Qoa_File 
    {
        const header: FileHeader
        const frames: array<Frame?>

        constructor(h: FileHeader)
            requires h.Samples >= 0
        {
            header, frames := h, new Frame?[h.Samples / (256 * 20)];
        }
    } 

    
    method Decoder(file: seq<bv8>) returns (qoa: Qoa_File) 
    {
    }
}

method Main(args: seq<string>) {
    if |args| != 1 {
        return;
    }

    var input := args;
    print "\"", input, "\"";
    
}