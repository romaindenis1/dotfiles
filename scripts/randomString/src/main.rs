use rand::Rng;
use std::env;

fn print_help(program_name: &str) {
    println!("Random String Generator");
    println!();
    println!("Usage:");
    println!("  {} <length> <charset_type>", program_name);
    println!();
    println!("Arguments:");
    println!("  <length>         Number of characters in the string (e.g., 16)");
    println!("  <charset_type>   Type of characters to include in the string:");
    println!("                   - alpha    : A–Z, a–z");
    println!("                   - digit    : 0–9");
    println!("                   - alnum    : A–Z, a–z, 0–9");
    println!("                   - symbol   : Special characters only");
    println!("                   - all      : Letters, digits, and symbols");
    println!("                   - username : Valid username characters");
    println!("                   - password : Common allowed password characters");
    println!();
    println!("Example:");
    println!("  {} 20 all", program_name);
    println!("  {} 16 username", program_name);
    println!("  {} 32 password", program_name);
    println!();
}

fn get_charset(charset_type: &str) -> Option<&'static [u8]> {
    match charset_type {
        "alpha" => Some(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"),
        "digit" => Some(b"0123456789"),
        "alnum" => Some(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"),
        "symbol" => Some(b"!@#$%^&*()-_=+[]{}|;:',.<>?/`~"),
        "all" => Some(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:',.<>?/`~"),
        "username" => Some(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 _-."), 
        "password" => Some(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:',.<>?/`~\"\\"),
        _ => None,
    }
}

fn generate_random_string(length: usize, charset: &[u8]) -> String {
    let mut rng = rand::thread_rng();
    (0..length)
        .map(|_| {
            let idx = rng.gen_range(0..charset.len());
            charset[idx] as char
        })
        .collect()
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program_name = &args[0];

    if args.len() == 2 && (args[1] == "--help" || args[1] == "-h") {
        print_help(program_name);
        return;
    }

    if args.len() != 3 {
        eprintln!("Invalid arguments. Use '--help' to see usage.");
        std::process::exit(1);
    }

    let length = match args[1].parse::<usize>() {
        Ok(n) if n > 0 => n,
        _ => {
            eprintln!("Error: '{}' is not a valid positive length.", args[1]);
            std::process::exit(1);
        }
    };

    let charset = match get_charset(&args[2]) {
        Some(c) => c,
        None => {
            eprintln!("Error: Unknown charset type '{}'. Use '--help' to see options.", args[2]);
            std::process::exit(1);
        }
    };

    let result = generate_random_string(length, charset);
    println!("{}", result);
}

