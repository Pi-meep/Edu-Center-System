/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

/**
 *
 * @author ASUS
 */
/**
 *
 * @author ASUS
 */
public class FileUploadUtils {

    /**
     * @param part phần multipart upload
     * @param context ServletContext để tính đường dẫn
     * @return đường dẫn tương đối lưu vào DB, ví dụ "certs/abc123.jpg"
     */
    public static String saveFile(Part part, String subDir, ServletContext context) throws IOException {
        // 1) Tên file ngẫu nhiên
        String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String ext = getFileExtension(submitted);
        String randomName = UUID.randomUUID().toString()
                + (ext.isEmpty() ? "" : "." + ext);

        // 2) Tính real path đến folder project/web/assets/certs
        //    getRealPath("/") thường trả về ".../build/web/"
        String explodedWeb = context.getRealPath("/");                    // .../build/web/
        File buildWeb = new File(explodedWeb);
        File projectRoot = buildWeb.getParentFile().getParentFile();      // .../EduCenter/
        File target = new File(projectRoot,
                "web/assets/certs");                        // .../EduCenter/web/assets/certs
        if (!target.exists()) {
            target.mkdirs();
        }

        // 3) Ghi file
        File dest = new File(target, randomName);
        part.write(dest.getAbsolutePath());

        // 4) Trả về đường dẫn tương đối cho client + lưu DB
        return "certs/" + randomName;
    }

    private static String getFileExtension(String name) {
        int dot = name.lastIndexOf('.');
        return dot > 0 && dot < name.length() - 1
                ? name.substring(dot + 1) : "";
    }
}
