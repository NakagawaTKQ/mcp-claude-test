/**
 * Hello Worldを出力するTypeScriptプログラム
 */

// メッセージを出力する関数
function sayHello(name: string = "World"): string {
    return `Hello, ${name}!`;
}

// メイン処理
function main(): void {
    const message = sayHello();
    console.log(message);
    
    // 名前を指定した場合
    const customMessage = sayHello("TypeScript");
    console.log(customMessage);
}

// プログラム実行
main();
