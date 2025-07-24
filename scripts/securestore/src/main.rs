mod encrypt;
mod decrypt;

use std::{
    env,
    fs,
    path::PathBuf,
    process,
};

fn print_help() {
    println!("Usage:");
    println!("  securestore -e <source_folder> <output_file> <password_file> [-w]");
    println!("    Encrypt the <source_folder> into <output_file> using the password from <password_file>.");
    println!("    Use -w if running on Windows (stores output on Desktop).");
    println!();
    println!("  securestore -d <encrypted_file> <output_folder> <password_file> [-w]");
    println!("    Decrypt the <encrypted_file> into <output_folder> using the password from <password_file>.");
    println!("    Use -w if running on Windows (stores output on Desktop).");
    println!();
    println!("Dumb errors (I made more than once):");
    println!("  - Make sure you specify all required arguments in the correct order.");
    println!("    For decrypt, it must be: -d <encrypted_file> <output_folder> <password_file> [-w]");
    println!("  - On Windows, if you see '.' is not recognized as a command, use '.\\' before executable name.");
    println!();
    println!("Examples:");
    println!("  securestore -e my_notes backup.enc pwd.txt -w");
    println!("  securestore -d backup.enc restored_notes pwd.txt -w");
    println!();
}


fn get_default_output_dir(is_windows: bool) -> Option<PathBuf> {
    if is_windows {
        env::var("USERPROFILE").ok().map(|mut userprofile| {
            let mut path = PathBuf::from(userprofile);
            path.push("Desktop");
            path
        })
    } else {
        env::var("HOME").ok().map(PathBuf::from)
    }
}

fn read_password_from_file(path: &str) -> String {
    match fs::read_to_string(path) {
        Ok(pw) => pw.trim().to_string(),
        Err(e) => {
            eprintln!("Failed to read password file '{}': {}", path, e);
            process::exit(1);
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 5 {
        print_help();
        process::exit(1);
    }

    let mut is_windows = false;
    let mut args_cleaned = vec![args[0].clone()];

    for arg in &args[1..] {
        if arg == "-w" {
            is_windows = true;
        } else {
            args_cleaned.push(arg.clone());
        }
    }

    let mode = &args_cleaned[1];

    match mode.as_str() {
        "-e" => {
            if args_cleaned.len() < 5 {
                eprintln!("Usage: {} -e <source_folder> <output_file> <password_file> [-w]", args[0]);
                process::exit(1);
            }

            let source = &args_cleaned[2];
            let output_file = &args_cleaned[3];
            let password_file = &args_cleaned[4];
            let password = read_password_from_file(password_file);

            if let Err(e) = encrypt::run(source, output_file, &password) {
                eprintln!("Encryption failed: {}", e);
                process::exit(1);
            }
        }

        "-d" => {
            if args_cleaned.len() < 5 {
                eprintln!("Usage: {} -d <encrypted_file> <output_folder> <password_file> [-w]", args[0]);
                process::exit(1);
            }

            let encrypted_file = &args_cleaned[2];
            let output_folder = &args_cleaned[3];
            let password_file = &args_cleaned[4];
            let password = read_password_from_file(password_file);

            if let Err(e) = decrypt::run(encrypted_file, output_folder, &password) {
                eprintln!("Decryption failed: {}", e);
                process::exit(1);
            }
        }

        _ => {
            print_help();
            process::exit(1);
        }
    }
}
