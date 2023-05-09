use bitvec::prelude::*;

fn main() {
    let y = 19.036236263_f32;
    //let x = 116.3906_f32;
    let x = 47.02345234657234_f32;
   //let y = 39.92324_f32;



   // let ymin = -90_f32;
   // let ymax = 90_f32;
    

    // even bits and odd bits are treated differently
    // Z order is odd and N order is even?
    let mut xbits: Vec<bool> = Vec::with_capacity(32);
    let mut ybits: Vec<bool> = Vec::with_capacity(32);

    //let xmin = -180_f32;
    //let xmax = 180_f32;

    let mut xs = vec![-180_f32, 0.0, 180.0];
    let mut ys = vec![-90_f32, 0.0, 90.0];



    for _ in 0..32 {

        xs[0] = if x >= xs[1] {
            xbits.push(true);
            xs[1]
        } else {
            xs[0]
        };

        xs[2] = if x < xs[1] {
            xbits.push(false);
            xs[1]
        } else {
            xs[2]
        };

        xs[1] = (xs[0] + xs[2]) / 2_f32;

        // handle lats
        ys[0] = if y >= ys[1] {
            ybits.push(true);
            ys[1]
        } else {
            ys[0]
        };

        ys[2] = if y < ys[1] {
            ybits.push(false);
            ys[1]
        } else {
            ys[2]
        };

        ys[1] = (ys[0] + ys[2]) / 2_f32;

    }


    //let xbs: BitVec<_, Msb0> = BitVec::from_vec(xbits);
    let xbv: BitVec = xbits.into_iter().collect();
    let ybv: BitVec = ybits.into_iter().collect();

    let mut z: BitVec<u64, Msb0> = BitVec::with_capacity(64);

    // interleave bits
    for i in 0..32 {
        let xi = xbv[i];
        let yi = ybv[i];
        
        z.push(xi);
        z.push(yi);
    
    }

    let mut geohash = String::new();
    for chnk in z.chunks_exact(5) {
        let pos = chnk.load::<u8>() as usize;
        geohash.push_str(BASE32_CODES[pos].to_string().as_str());
    }

    println!("Geohash: {}", geohash);
}
// https://github.com/georust/geohash/blob/main/src/core.rs
const BASE32_CODES: [char; 32] = [
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'b', 'c', 'd', 'e', 'f', 'g',
    'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r',
    's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
];