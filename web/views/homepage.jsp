<%-- 
    Document   : homepage.jsp
    Created on : May 23, 2025, 4:29:19 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<% request.setAttribute("title", "Trang chủ");%>
<jsp:include page="layout/header.jsp" />

<style>
    .homepage-hero {
        background: linear-gradient(135deg, rgba(102,126,234,0.9), rgba(118,75,162,0.9)), url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><defs><pattern id="bg" width="50" height="50" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="2" fill="%23ffffff" opacity="0.1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23bg)"/></svg>');
        padding: 150px 0 100px;
        text-align: center;
        color: white;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        justify-content: center;
        position: relative;
    }

    .homepage-hero-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 2rem;
    }

    .homepage-hero h1 {
        font-size: 3.5rem;
        margin-bottom: 1rem;
        font-weight: 700;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        animation: homepageFadeInUp 1s ease;
    }

    .homepage-hero p {
        font-size: 1.3rem;
        margin-bottom: 2rem;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
        opacity: 0.95;
        animation: homepageFadeInUp 1s ease 0.2s both;
    }

    .homepage-hero-buttons {
        display: flex;
        gap: 1rem;
        justify-content: center;
        flex-wrap: wrap;
        animation: homepageFadeInUp 1s ease 0.4s both;
    }

    /* Features Section */
    .homepage-features {
        padding: 100px 0;
        background: #f8f9ff;
    }

    .homepage-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 2rem;
    }

    .homepage-section-title {
        text-align: center;
        margin-bottom: 4rem;
    }

    .homepage-section-title h2 {
        font-size: 2.5rem;
        color: #333;
        margin-bottom: 1rem;
        position: relative;
    }

    .homepage-section-title h2::after {
        content: '';
        width: 60px;
        height: 4px;
        background: linear-gradient(45deg, #ff6b6b, #feca57);
        display: block;
        margin: 1rem auto;
        border-radius: 2px;
    }

    .homepage-features-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
        gap: 2rem;
    }

    .homepage-feature-card {
        background: white;
        padding: 2.5rem;
        border-radius: 20px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        transition: all 0.3s ease;
        border: 1px solid #e1e8ed;
    }

    .homepage-feature-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    }

    .homepage-feature-icon {
        font-size: 3rem;
        margin-bottom: 1.5rem;
        display: block;
    }

    .homepage-feature-card h3 {
        font-size: 1.5rem;
        margin-bottom: 1rem;
        color: #333;
    }

    .homepage-feature-card p {
        color: #666;
        line-height: 1.6;
        margin-bottom: 1.5rem;
    }

    /* Stats Section */
    .homepage-stats {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 80px 0;
        color: white;
    }

    .homepage-stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 2rem;
        text-align: center;
    }

    .homepage-stat-item h3 {
        font-size: 2.5rem;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }

    .homepage-stat-item p {
        font-size: 1.1rem;
        opacity: 0.9;
    }

    /* CTA Section */
    .homepage-cta {
        padding: 100px 0;
        background: #fff;
        text-align: center;
    }

    .homepage-cta h2 {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        color: #333;
    }

    .homepage-cta p {
        font-size: 1.2rem;
        color: #666;
        margin-bottom: 2rem;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
    }

    /* Buttons */
    .homepage-btn {
        padding: 0.7rem 1.5rem;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
    }

    .homepage-btn-outline {
        background: transparent;
        color: white;
        border: 2px solid white;
    }

    .homepage-btn-outline:hover {
        background: white;
        color: #667eea;
        transform: translateY(-2px);
    }

    .homepage-btn-primary {
        background: linear-gradient(45deg, #ff6b6b, #feca57);
        color: white;
        border: none;
    }

    .homepage-btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(255,107,107,0.4);
    }

    /* Animations */
    @keyframes homepageFadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Responsive */
    @media (max-width: 768px) {
        .homepage-hero h1 {
            font-size: 2.5rem;
        }
        
        .homepage-hero-buttons {
            flex-direction: column;
            align-items: center;
        }
        
        .homepage-features-grid {
            grid-template-columns: 1fr;
        }
    }

    /* Carousel Styles */
    .carousel-container {
      position: relative;
      width: 100%;
      height: 600px;
      overflow: hidden;
      background: #222;
    }
    .carousel-slide {
      position: absolute;
      width: 100%;
      height: 100%;
      opacity: 0;
      transition: opacity 1s;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .carousel-slide.active {
      opacity: 1;
      z-index: 2;
    }
    .carousel-img {
      width: 100%;
      height: 600px;
      object-fit: cover;
      filter: brightness(0.5);
    }
    .carousel-caption {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: #fff;
      text-align: center;
      z-index: 3;
    }
    .carousel-dots {
      position: absolute;
      bottom: 30px;
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      gap: 10px;
      z-index: 20;
    }
    .carousel-dot {
      width: 14px;
      height: 14px;
      border-radius: 50%;
      background: #fff;
      opacity: 0.5;
      cursor: pointer;
      transition: opacity 0.3s;
      border: 2px solid #fff;
    }
    .carousel-dot.active {
      opacity: 1;
      background: #ff6b6b;
    }
    @media (max-width: 768px) {
      .carousel-container, .carousel-img {
        height: 300px;
      }
    }
</style>

<!-- Hero Section as Carousel -->
<section class="homepage-hero" id="home" style="padding:0; min-height:unset; position:relative;">
  <div class="carousel-container">
    <div class="carousel-slide active">
      <img src="<%= request.getContextPath()%>/assets/image_4.jpg" alt="Slide 1" class="carousel-img">
      <div class="carousel-caption">
        <h1>Nâng Tầm Tri Thức<br>Vững Bước Tương Lai</h1>
        <p>Trung tâm dạy thêm hàng đầu với đội ngũ giáo viên giàu kinh nghiệm, phương pháp giảng dạy hiện đại và môi trường học tập thân thiện</p>
        <div class="homepage-hero-buttons">
          <a href="danh-sach-lop" class="homepage-btn homepage-btn-primary" style="font-size: 1.1rem; padding: 1rem 2rem;">Danh Sách Lớp</a>
          <a href="gioi-thieu" class="homepage-btn homepage-btn-outline" style="font-size: 1.1rem; padding: 1rem 2rem;">Tìm Hiểu Thêm</a>
        </div>
      </div>
    </div>
    <div class="carousel-slide">
      <img src="<%= request.getContextPath()%>/assets/image_1.jpg" alt="Slide 2" class="carousel-img">
      <div class="carousel-caption">
        <h1>Giáo Viên Tận Tâm</h1>
        <p>Đội ngũ giáo viên chuyên nghiệp, luôn đồng hành cùng học sinh trên con đường chinh phục tri thức.</p>
      </div>
    </div>
    <div class="carousel-slide">
      <img src="<%= request.getContextPath()%>/assets/pic1.jpg" alt="Slide 3" class="carousel-img">
      <div class="carousel-caption">
        <h1>Môi Trường Năng Động</h1>
        <p>Không gian học tập hiện đại, thân thiện, khơi dậy niềm đam mê học hỏi cho học sinh.</p>
      </div>
    </div>
    <div class="carousel-dots"></div>
  </div>
</section>

<!-- Features Section -->
<section class="homepage-features" id="courses">
    <div class="homepage-container">
        <div class="homepage-section-title">
            <h2>Tại Sao Chọn EduCenter?</h2>
            <p>Chúng tôi cam kết mang đến chất lượng giáo dục tốt nhất cho học sinh</p>
        </div>
        <div class="homepage-features-grid">
            <div class="homepage-feature-card">
                <span class="homepage-feature-icon">👨‍🏫</span>
                <h3>Giáo Viên Chất Lượng</h3>
                <p>Đội ngũ giáo viên có trình độ chuyên môn cao, kinh nghiệm giảng dạy phong phú và tâm huyết với nghề</p>
                <a href="danh-sach-giao-vien" class="homepage-btn homepage-btn-primary">Xem Chi Tiết</a>
            </div>
            <div class="homepage-feature-card">
                <span class="homepage-feature-icon">📚</span>
                <h3>Chương Trình Đa Dạng</h3>
                <p>Các khóa học từ cơ bản đến nâng cao, phù hợp với mọi độ tuổi và trình độ học sinh</p>
                <a href="danh-sach-lop" class="homepage-btn homepage-btn-primary">Khám Phá</a>
            </div>
            <div class="homepage-feature-card">
                <span class="homepage-feature-icon">🏆</span>
                <h3>Kết Quả Vượt Trội</h3>
                <p>95% học sinh đạt điểm cao trong các kỳ thi quan trọng và nâng cao thành tích học tập</p>
                <a href="gioi-thieu" class="homepage-btn homepage-btn-primary">Thành Tích</a>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="homepage-stats">
    <div class="homepage-container">
        <div class="homepage-stats-grid">
            <div class="homepage-stat-item">
                <h3>${stats.studentCount != null ? stats.studentCount : '500'}</h3>
                <p>Học Sinh Đang Theo Học</p>
            </div>
            <div class="homepage-stat-item">
                <h3>${stats.teacherCount != null ? stats.teacherCount : '50'}</h3>
                <p>Giáo Viên Chuyên Nghiệp</p>
            </div>
            <div class="homepage-stat-item">
                <h3>${stats.courseCount != null ? stats.courseCount : '20'}</h3>
                <p>Khóa Học Chất Lượng Đang Hoạt Động</p>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="homepage-cta">
    <div class="homepage-container">
        <h2>Bắt Đầu Hành Trình Học Tập Ngay Hôm Nay</h2>
        <p>Đăng ký ngay để được tư vấn miễn phí và nhận ưu đãi đặc biệt cho khóa học đầu tiên</p>
        <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
            <a href="dang-ky" class="homepage-btn homepage-btn-primary" style="font-size: 1.1rem; padding: 1rem 2rem;">Tư Vấn Miễn Phí</a>
            <a href="tel:0123456789" class="homepage-btn" style="background: #f8f9fa; color: #333; font-size: 1.1rem; padding: 1rem 2rem;">Gọi Ngay: 0123 456 789</a>
        </div>
    </div>
</section>

<script>
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.homepage-feature-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'all 0.6s ease';
        observer.observe(card);
    });

    // Carousel logic
    const slides = document.querySelectorAll('.carousel-slide');
    const dotsContainer = document.querySelector('.carousel-dots');
    let currentSlide = 0;
    let carouselInterval;

    function showSlide(index) {
      slides.forEach((slide, i) => {
        slide.classList.toggle('active', i === index);
        if (dotsContainer.children[i]) {
          dotsContainer.children[i].classList.toggle('active', i === index);
        }
      });
      currentSlide = index;
    }

    function nextSlide() {
      let next = (currentSlide + 1) % slides.length;
      showSlide(next);
    }

    // Create dots
    slides.forEach((_, i) => {
      const dot = document.createElement('div');
      dot.className = 'carousel-dot' + (i === 0 ? ' active' : '');
      dot.addEventListener('click', () => {
        showSlide(i);
        resetInterval();
      });
      dotsContainer.appendChild(dot);
    });

    function resetInterval() {
      clearInterval(carouselInterval);
      carouselInterval = setInterval(nextSlide, 4000);
    }

    // Start carousel
    carouselInterval = setInterval(nextSlide, 4000);

    // Show first slide
    showSlide(0);
</script>

<jsp:include page="layout/footer.jsp" /> 
